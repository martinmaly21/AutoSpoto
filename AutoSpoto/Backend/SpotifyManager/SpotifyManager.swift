
//
//  SpotifyManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation
import AppKit

//this is where shared Spotify code b/t scheduler and main app goes
class SpotifyManager {
    private static func url(
        path: String,
        params: [String: Any]? = nil,
        isTokenFetch: Bool = false
    ) -> URL {
        var queryString = ""
        if let params = params {
            queryString = "?"
            params.forEach { k, v in
                queryString += "\(k)=\(v)&"
            }
        }
        let path = path.trimmingCharacters(in: .init(charactersIn: "/"))
        queryString = queryString.trimmingCharacters(in: .init(charactersIn: "&"))
        let urlString = "\(isTokenFetch ? AutoSpotoConstants.URL.spotifyAuthEndpoint : AutoSpotoConstants.URL.spotifyWebAPIEndPoint)/\(path)/\(queryString)"
        return URL(string: urlString)!
    }
    
    private static func headers(
        isTokenFetch: Bool,
        isImageUpload: Bool
    ) async throws -> [String: String] {
        var headers = [
            AutoSpotoConstants.HTTPHeaders.contentType: isImageUpload ? "image/jpeg" : "application/x-www-form-urlencoded",
        ]
        
        guard !isTokenFetch else {
            headers[AutoSpotoConstants.HTTPHeaders.authorization] = "Basic \((Data("\(clientID):\(clientSecret)".utf8).base64EncodedString()))"
            return headers
        }
        
        if var token = SpotifyTokenManager.readToken() {
            if token.accessTokenHasExpired {
                token = try await refreshAndSaveToken(expiredToken: token)
            }
            headers[AutoSpotoConstants.HTTPHeaders.authorization] = "Bearer \(token.access_token)"
        }
        
        return headers
    }
    
    internal static func http(
        method: HTTPMethodType,
        path: String,
        isTokenFetch: Bool = false
    ) async throws -> Data {
        let httpURL: URL
        switch method {
        case .get(let queryParams):
            httpURL = url(path: path, params: queryParams, isTokenFetch: isTokenFetch)
        case .post, .put, .putImage, .delete:
            httpURL = url(path: path, isTokenFetch: isTokenFetch)
        }
        
        var request = URLRequest(url: httpURL)
        request.httpMethod = method.httpMethod
        
        var isImageUpload = false
        if case .putImage = method {
            isImageUpload = true
        }
        
        //update headers
        let headers = try await headers(isTokenFetch: isTokenFetch, isImageUpload: isImageUpload)
        for (headerField, headerValue) in headers {
            request.setValue(
                headerValue,
                forHTTPHeaderField: headerField
            )
        }
        
        if let methodData = method.data {
            var data: Data?
            if isTokenFetch {
                data = methodData.map { "\($0)=\($1)" }
                    .joined(separator: "&")
                    .data(using: .utf8)
            } else if isImageUpload {
                //special case for when a user
                guard let imageBase64Data = methodData[AutoSpotoConstants.HTTPParameter.playlistCoverImage] as? Data else {
                    fatalError("Could not get base64image")
                }
                
                data = imageBase64Data
            } else {
                data = try? JSONSerialization.data(withJSONObject: methodData)
            }
            
            request.httpBody = data
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  validStatusCode(httpURLResponse.statusCode) else {
                
                let parsedData = String(decoding: data, as: UTF8.self)
                
                //Is there a better way of handling this?? What if another non-chat update http request returns a 403?
                if parsedData.contains("\"status\" : 403") {
                    throw AutoSpotoError.chatWasDeleted
                } else {
                    throw AutoSpotoError.unexpectedHTTPUrlResponse
                }
            }
            
            return data
        } catch let error {
            print("😭 ERROR: \(error)")
            throw error
        }
    }
    
    private static func validStatusCode(_ statusCode: Int) -> Bool {
        switch statusCode {
        case AutoSpotoConstants.HTTPStatus.ok,
            AutoSpotoConstants.HTTPStatus.created,
            AutoSpotoConstants.HTTPStatus.accepted,
            AutoSpotoConstants.HTTPStatus.noContent,
            AutoSpotoConstants.HTTPStatus.movedPermanently,
            AutoSpotoConstants.HTTPStatus.found,
            AutoSpotoConstants.HTTPStatus.movedTemporarily,
            AutoSpotoConstants.HTTPStatus.temporaryRedirect,
            AutoSpotoConstants.HTTPStatus.permanentRedirect:
            return true
        default:
            return false
        }
    }
    
    public static func refreshAndSaveToken(expiredToken: JSONToken) async throws -> JSONToken {
        let params = [
            AutoSpotoConstants.HTTPParameter.grant_type: "refresh_token",
            AutoSpotoConstants.HTTPParameter.refresh_token: expiredToken.refresh_token
        ]
        let data = try await http(method: .post(data: params), path: "/token", isTokenFetch: true)
    
        let spotifyToken = try JSONDecoder().decode(SpotifyToken.self, from: data)
            
        SpotifyTokenManager.writeToken(spotifyToken: spotifyToken)
        
        return JSONToken(spotifyToken: spotifyToken)
    }
    
    public static func updatePlaylist(
        spotifyPlaylistID: String,
        tracks: [Track],
        lastUpdated: Date?
    ) async throws -> Date? {
        let filteredTracksChunks = try await filterChat(for: tracks, lastUpdated: lastUpdated ?? Date(timeIntervalSince1970: 0))
        
        //add tracks to playlist
        for filteredTracksChunk in filteredTracksChunks {
            let params: [String : Any] = [
                AutoSpotoConstants.HTTPParameter.uris: filteredTracksChunk.map { "spotify:track:\($0.spotifyID)" }
            ]

            let _ = try await http(method: .post(data: params), path: "/playlists/\(spotifyPlaylistID)/tracks")
        }
        
        if filteredTracksChunks.isEmpty {
            return nil
        } else {
            //only update db if playlist was actually updated (i.e. there are traacks)
            let dateUpdated = Date()
            DatabaseManager.shared.updateLastUpdated(for: spotifyPlaylistID, with: dateUpdated.timeIntervalSince1970)
            return dateUpdated
        }
    }
    
    //this method is responsible for filtering out all invalid IDs from a chat before creating a playlist on Spotify
    private static func filterChat(
        for tracks: [Track],
        lastUpdated: Date
    ) async throws -> [[Track]] {
        //this contains an array of arrays of a maximum of 50 length. Note: some of the IDs in these arrays may be invalid
        let unfilteredTrackChunks: [[Track]] = tracks
            .filter { $0.timeStamp > lastUpdated }
            .splitIntoChunks(of: AutoSpotoConstants.Limits.maximumNumberOfSpotifyTracksPerMetadataFetchCall)
        
        var filteredTracksChunks: [[Track]] = []
        
        for unfilteredTrackChunk in unfilteredTrackChunks {
            let filteredTrackChunk = try await fetchTrackMetadata(for: unfilteredTrackChunk).filter { !$0.errorFetchingTrackMetadata }
            filteredTracksChunks.append(filteredTrackChunk)
        }
        
        //this contains an array of arrays of a maximum of 100 length. ALL IDs should be valid
        filteredTracksChunks = filteredTracksChunks.flatMap { $0 }.splitIntoChunks(of: AutoSpotoConstants.Limits.maximumNumberOfSpotifyTracksPerAddToPlaylistCall)
        
        return filteredTracksChunks
    }
    
    public static func fetchTrackMetadata(for tracks: [Track]) async throws -> [Track] {
        let params = [
            AutoSpotoConstants.HTTPParameter.ids: tracks.map { $0.spotifyID }.joined(separator: ","),
        ]
        
        let data = try await http(method: .get(queryParams: params), path: "/tracks")
        
        let spotifyTracks = try JSONDecoder().decode(SpotifyTracksResponse.self, from: data)
        
        var tracksWithMetadata: [Track] = []
        for (index, spotifyTrack) in spotifyTracks.tracks.enumerated() {
            tracksWithMetadata.append(Track(longTrackCodable: spotifyTrack, existingTrack: tracks[index]))
        }
        
        return tracksWithMetadata
    }
}
