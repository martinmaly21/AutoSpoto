//
//  SpotifyManager+App.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-14.
//

import Foundation
import AppKit

//this is where only app specific Spotify code goes
extension SpotifyManager {
    //MARK: - Auth
    public static func fetchAndSaveToken(code: String) async throws {
        let params = [
            AutoSpotoConstants.HTTPParameter.grant_type: "authorization_code",
            AutoSpotoConstants.HTTPParameter.redirect_uri: redirectURI,
            AutoSpotoConstants.HTTPParameter.code: code,
        ]
        let data = try await http(method: .post(data: params), path: "/token", isTokenFetch: true)
        
        let spotifyToken = try JSONDecoder().decode(SpotifyToken.self, from: data)
        
        SpotifyTokenManager.writeToken(spotifyToken: spotifyToken)
    }
    
    public static func fetchAndSaveUserSpotifyID() async throws {
        let data = try await http(method: .get(queryParams: nil), path: "/me")
        let spotifyUser = try JSONDecoder().decode(SpotifyUser.self, from: data)
        UserDefaultsManager.spotifyUser = spotifyUser
    }
    
    //MARK: - Playlists
    //returns the playlist ID of the created spotify playlist
    public static func createPlaylistAndAddTracks(
        for chat: Chat,
        desiredPlaylistName: String
    ) async throws {
        //create playlist
        let spotifyPlaylistID = try await createPlaylist(desiredPlaylistName: desiredPlaylistName)
            
        chat.spotifyPlaylistID = spotifyPlaylistID
        DatabaseManager.shared.insert(spotifyPlaylistID, for: chat.ids)
        let dateUpdated = try await updatePlaylist(spotifyPlaylistID: spotifyPlaylistID, tracks: chat.tracks, lastUpdated: chat.lastUpdated)
        chat.lastUpdated = dateUpdated
        
        //finally, update cover image for chat
        try await addCoverImageToPlaylist(for: chat)
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
    
    public static func addCoverImageToPlaylist(for chat: Chat) async throws {
        guard let spotifyPlaylistID = chat.spotifyPlaylistID,
              let autoSpotoPlaylistImage = NSImage(named: "PlaylistCoverImage") else {
            fatalError("Could not get spotifyPlaylistID for chat")
        }
        
        let autoSpotoPlaylistImageBase64Data = autoSpotoPlaylistImage.jpegData().base64EncodedData()
        
        let params: [String : Any] = [
            AutoSpotoConstants.HTTPParameter.playlistCoverImage: autoSpotoPlaylistImageBase64Data
        ]
        
        let _ = try await http(method: .putImage(data: params), path: "/playlists/\(spotifyPlaylistID)/images")
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
