//
//  SpotifyManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

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
    
    private static func headers(isTokenFetch: Bool) async throws -> [String: String] {
        var headers = [
            AutoSpotoConstants.HTTPHeaders.contentType: "application/x-www-form-urlencoded",
        ]
        
        guard !isTokenFetch else {
            headers[AutoSpotoConstants.HTTPHeaders.authorization] = "Basic \((Data("\(clientID):\(clientSecret)".utf8).base64EncodedString()))"
            return headers
        }
        
        if var keychainToken = KeychainManager.standard.read(
            service: AutoSpotoConstants.KeyChain.service,
            account: AutoSpotoConstants.KeyChain.account,
            type: KeychainToken.self
        ) {
            if keychainToken.accessTokenHasExpired {
                keychainToken = try await refreshAndSaveToken(expiredKeychainToken: keychainToken)
            }
            
            headers[AutoSpotoConstants.HTTPHeaders.authorization] = "Bearer \(keychainToken.access_token))"
        }
        
        return headers
    }
    
    private static func http(
        method: HTTPMethodType,
        path: String,
        isTokenFetch: Bool = false
    ) async throws -> Data {
        let httpURL: URL
        switch method {
        case .get(let queryParams):
            httpURL = url(path: path, params: queryParams, isTokenFetch: isTokenFetch)
        case .post, .put, .delete:
            httpURL = url(path: path, isTokenFetch: isTokenFetch)
        }
        
        var request = URLRequest(url: httpURL)
        request.httpMethod = method.httpMethod
        
        //update headers
        let headers = try await headers(isTokenFetch: isTokenFetch)
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
                print("‼️ ERROR: \(parsedData)")
                throw AutoSpotoError.unexpectedHTTPUrlResponse
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
   
    //MARK: - Auth
    public static func fetchAndSaveToken(code: String) async throws {
        let params = [
            AutoSpotoConstants.HTTPParameter.grant_type: "authorization_code",
            AutoSpotoConstants.HTTPParameter.redirect_uri: redirectURI,
            AutoSpotoConstants.HTTPParameter.code: code,
        ]
        let data = try await http(method: .post(data: params), path: "/token", isTokenFetch: true)
        let spotifyToken = try JSONDecoder().decode(SpotifyToken.self, from: data)
        
        _ = KeychainManager.saveSpotifyTokenInKeychain(spotifyToken: spotifyToken)
    }
    
    public static func refreshAndSaveToken(expiredKeychainToken: KeychainToken) async throws -> KeychainToken {
        let params = [
            AutoSpotoConstants.HTTPParameter.grant_type: "refresh_token",
            AutoSpotoConstants.HTTPParameter.refresh_token: expiredKeychainToken.refresh_token
        ]
        let data = try await http(method: .post(data: params), path: "/token", isTokenFetch: true)
        let spotifyToken = try JSONDecoder().decode(SpotifyToken.self, from: data)
        
        let keychainToken = KeychainManager.saveSpotifyTokenInKeychain(spotifyToken: spotifyToken)
        
        return keychainToken
    }
    
    public static func fetchAndSaveUserSpotifyID() async throws {
        let data = try await http(method: .get(queryParams: nil), path: "/me")
        let spotifyUser = try JSONDecoder().decode(SpotifyUser.self, from: data)
        UserDefaultsManager.spotifyUser = spotifyUser
    }
    
    //MARK: - Playlists
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
    
    //this method is responsible for filtering out all invalid IDs from a chat
    private static func filterChat(
        for chat: Chat
    ) async throws -> [[Track]]? {
        //this contains an array of arrays of a maximum of 50 length. Note: some of the IDs in these arrays may be invalid
        let unfilteredTrackChunks = chat.tracks.splitIntoChunks(of: AutoSpotoConstants.Limits.maximumNumberOfSpotifyTracksPerMetadataFetchCall)
        
        var filteredTracksChunks: [[Track]] = []
        
        for unfilteredTrackChunk in unfilteredTrackChunks {
            let filteredTrackChunk = try await fetchTrackMetadata(for: unfilteredTrackChunk).filter { !$0.errorFetchingTrackMetadata }
            filteredTracksChunks.append(filteredTrackChunk)
        }
        guard !filteredTracksChunks.isEmpty else {
            return nil
        }
        
        //this contains an array of arrays of a maximum of 100 length. ALL IDs should be valid
        filteredTracksChunks = filteredTracksChunks.flatMap { $0 }.splitIntoChunks(of: AutoSpotoConstants.Limits.maximumNumberOfSpotifyTracksPerAddToPlaylistCall)
        
        return filteredTracksChunks
    }
    
    //returns the playlist ID of the created spotify playlist
    public static func createPlaylistAndAddTracks(
        for chat: Chat,
        desiredPlaylistName: String
    ) async throws {
        guard let filteredTracksChunks = try await filterChat(for: chat) else {
            throw AutoSpotoError.chatHasNoValidIDs
        }
        
        //create playlist
        chat.spotifyPlaylistID = try await createPlaylist(desiredPlaylistName: desiredPlaylistName)
        let _ = try DatabaseManager()!.insertSpotifyPlaylistDB(from: chat.spotifyPlaylistID!, selectedChatID: chat.ids)
        try await updatePlaylist(for: chat)
    }
    
    private static func createPlaylist(
        desiredPlaylistName: String
    ) async throws -> String {
        let params: [String : Any] = [
            AutoSpotoConstants.HTTPParameter.name: desiredPlaylistName
        ]
        
        try await SpotifyManager.fetchAndSaveUserSpotifyID()
        
        let data = try await http(method: .post(data: params), path: "/users/\(UserDefaultsManager.spotifyUser.id)/playlists")
        
        let spotifyPlaylist = try JSONDecoder().decode(SpotifyPlaylist.self, from: data)
        return spotifyPlaylist.id
    }
    
    //TODO: filter out tracks that have already been added? Maybe pass in lastUPdated param to this method and check that to the time stamp of each track
    //OR more likely the lastUpdated param should be a property on Chat
    public static func updatePlaylist(
        for chat: Chat
    ) async throws {
        guard let spotifyPlaylistID = chat.spotifyPlaylistID else {
            fatalError("Could not get spotifyPlaylistID for chat")
        }
        
        guard let filteredTracksChunks = try await filterChat(for: chat) else {
            throw AutoSpotoError.chatHasNoValidIDs
        }
        
        //add tracks to playlist
        for filteredTracksChunk in filteredTracksChunks {
            let params: [String : Any] = [
                AutoSpotoConstants.HTTPParameter.uris: filteredTracksChunk.map { "spotify:track:\($0.spotifyID)"}
            ]

            let _ = try await http(method: .post(data: params), path: "/playlists/\(spotifyPlaylistID)/tracks")
        }
        
        let dateUpdated = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let params: [String : Any] = [
            AutoSpotoConstants.HTTPParameter.description: String.localizedStringWithFormat(
                AutoSpotoConstants.Strings.CHAT_CREATED_BY_AUTOSPOTO_DESCRIPTION,
                dateFormatter.string(from: dateUpdated)
            )
        ]
        
        let _ = try await http(method: .put(data: params), path: "/playlists/\(spotifyPlaylistID)")
        let _ = try DatabaseManager()!.updateLastUpdatedDB(from: chat.spotifyPlaylistID!)
        //TODO: After the songs are updated we update the time in the last updated column of the database (dateUpdated)
    }
    
    public static func fetchPlaylist(for spotifyPlaylistID: String) async throws -> SpotifyPlaylist? {
        let params = [
            AutoSpotoConstants.HTTPParameter.fields: "\(AutoSpotoConstants.HTTPParameter.id),\(AutoSpotoConstants.HTTPParameter.images),\(AutoSpotoConstants.HTTPParameter.name)"
        ]
        let data = try await http(method: .get(queryParams: params), path: "/playlists/\(spotifyPlaylistID)")
        let spotifyPlaylist = try JSONDecoder().decode(SpotifyPlaylist.self, from: data)
        return spotifyPlaylist
    }
    
    //Use this method to check if a playist exists
    //Note: even 'deleted' playlists are fetchable for 90 days after they're 'deleted'
    public static func checkIfPlaylistExists(for spotifyPlaylistID: String) async throws -> Bool {
        let spotifyPlaylist = try await fetchPlaylist(for: spotifyPlaylistID)
        return spotifyPlaylist != nil
    }
}
