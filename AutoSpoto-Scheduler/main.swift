//
//  main.swift
//  AutoSpoto-Scheduler
//
//  Created by Andrew Caravaggio on 2023-07-05.
//

import Foundation

DatabaseManager.shared = DatabaseManager()
let trackedChats = DatabaseManager.shared.retrieveTrackedChats()

for trackedChat in trackedChats.rows {
    guard let trackedChatID = trackedChat["chatID"] as? Int,
          let trackedChatSpotifyPlaylistID = trackedChat["spotifyPlaylistID"] as? String,
          let trackedChatLastUpdated = trackedChat["lastUpdated"] as? Double else {
        fatalError("Could not get tracked chat information")
    }
    
    let trackedChatTracks = await DatabaseManager.shared.fetchSpotifyTracksWithNoMetadata(for: [trackedChatID])
    
    try await SpotifyManager.updatePlaylist(
        spotifyPlaylistID: trackedChatSpotifyPlaylistID,
        tracks: trackedChatTracks,
        lastUpdated: Date(timeIntervalSince1970: trackedChatLastUpdated)
    )
}
