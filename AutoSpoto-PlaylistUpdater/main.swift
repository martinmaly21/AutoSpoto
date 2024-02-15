//
//  main.swift
//  AutoSpoto-PlaylistUpdater
//
//  Created by Andrew Caravaggio on 2023-07-05.
//

import Foundation

guard let db = DatabaseManager() else {
    exit(1)
}

//log time that script has succesfully accessed chat.db
//this is used for onboarding to determine when playlist updater has been given full disk access
do {
    guard let autoSpotoURL = DiskAccessManager.autoSpotoURL else {
        exit(2)
    }
    
    try FileManager.default.createDirectory (at: autoSpotoURL, withIntermediateDirectories: true, attributes: nil)
    
    guard let playlistUpdaterValidationURL = DiskAccessManager.playlistUpdaterValidationURL else {
        exit(2)
    }
    
    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(Date().timeIntervalSince1970)
    try jsonData.write(to: playlistUpdaterValidationURL)
} catch {
    exit(3)
}

DatabaseManager.shared = db
let trackedChats = DatabaseManager.shared.retrieveTrackedChats()

for trackedChat in trackedChats.rows {
    guard let trackedChatID = trackedChat["chatID"] as? Int,
          let trackedChatSpotifyPlaylistID = trackedChat["spotifyPlaylistID"] as? String,
          let trackedChatLastUpdated = trackedChat["lastUpdated"] as? Double else {
        continue //fail silently
    }
    
    let trackedChatTracks = await DatabaseManager.shared.fetchSpotifyTracksWithNoMetadata(for: [trackedChatID])
    
    do {
        _ = try await SpotifyManager.updatePlaylist(
            spotifyPlaylistID: trackedChatSpotifyPlaylistID,
            tracks: trackedChatTracks,
            lastUpdated: Date(timeIntervalSince1970: trackedChatLastUpdated)
        )
    } catch let error as AutoSpotoError {
        if error == .chatWasDeleted {
            DatabaseManager.shared.remove(trackedChatSpotifyPlaylistID)
        }
    } catch {
        continue //fail silently
    }
}
