//
//  main.swift
//  AutoSpoto-PlaylistUpdater
//
//  Created by Andrew Caravaggio on 2023-07-05.
//

import Foundation

let groupIdentifier = "TODO_UPDATE_TEAM_ID.app.dependencies.dependencies.preferences"
let sharedUserDefaults = UserDefaults(suiteName: groupIdentifier)
guard let db = DatabaseManager() else {
    exit(1)
}
let libraryBookmarkData = sharedUserDefaults!.data(
        forKey: AutoSpotoConstants.UserDefaults.libraryBookmarkData
)


//print(libraryBookmarkData?.description)


//log time that script has succesfully accessed chat.db
//this is used for onboarding to determine when playlist updater has been given full disk access
do {
    // Resolve library bookmark data to URL
    var isStale = false
    let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData!, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)

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

if let sharedUserDefaults = sharedUserDefaults {
    // Set values in shared UserDefaults
    sharedUserDefaults.set(true, forKey: "SharedKey")
    sharedUserDefaults.synchronize()
}

DatabaseManager.shared = db
let trackedChats = DatabaseManager.shared.retrieveTrackedChats()

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
