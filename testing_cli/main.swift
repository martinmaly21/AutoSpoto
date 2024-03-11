//
//  main.swift
//  testing_cli
//
//  Created by Andrew Caravaggio on 2024-03-11.
//

import Foundation

let groupIdentifier = AutoSpotoConstants.UserDefaults.group_name
let sharedUserDefaults = UserDefaults(suiteName: groupIdentifier)
guard let db = DatabaseManager() else {
    exit(1)
}

guard let sharedUserDefaults = sharedUserDefaults else {
    print("Error: Shared UserDefaults is nil.")
    exit(2)
}

let libraryBookmarkData = sharedUserDefaults.data(
    forKey: AutoSpotoConstants.UserDefaults.libraryBookmarkData
)

do {
    // Resolve library bookmark data to URL
    var isStale = false
    let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData!, relativeTo: nil, bookmarkDataIsStale: &isStale )

    guard let autoSpotoURL = DiskAccessManager.autoSpotoURL else {
        print("Could not get autoSpotoURL.")
        exit(3)
    }

    DiskAccessManager.startAccessingSecurityScopedResource()

    // Create directory at autoSpotoURL
    try FileManager.default.createDirectory(at: autoSpotoURL, withIntermediateDirectories: true, attributes: nil)
    DiskAccessManager.stopAccessingSecurityScopedResource()

    guard let playlistUpdaterValidationURL = DiskAccessManager.playlistUpdaterValidationURL else {
        print("Could not get playlistUpdaterValidationURL.")
        exit(4)
    }

    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(Date().timeIntervalSince1970)

    DiskAccessManager.startAccessingSecurityScopedResource()

    // Write JSON data to playlistUpdaterValidationURL
    try jsonData.write(to: playlistUpdaterValidationURL)

    DiskAccessManager.stopAccessingSecurityScopedResource()
} catch {
    print("Error: \(error)")
    exit(5)
}


sharedUserDefaults.set(true, forKey: AutoSpotoConstants.UserDefaults.spotifyUser)
sharedUserDefaults.synchronize()

DatabaseManager.shared = db
let trackedChats = DatabaseManager.shared.retrieveTrackedChats()
print(trackedChats)
for trackedChat in trackedChats.rows {
    guard let trackedChatID = trackedChat["chatID"] as? Int,
          let trackedChatSpotifyPlaylistID = trackedChat["spotifyPlaylistID"] as? String,
          let trackedChatLastUpdated = trackedChat["lastUpdated"] as? Double else {
        continue // fail silently
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
        continue // fail silently
    }
}

