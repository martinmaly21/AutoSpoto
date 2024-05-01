//
//  main.swift
//  AutoSpoto-PlaylistUpdaterHelper
//
//  Created by Andrew Caravaggio on 2024-03-11.
//

import Foundation

let groupIdentifier = AutoSpotoConstants.UserDefaults.group_name
let sharedUserDefaults = UserDefaults(suiteName: groupIdentifier)


if UserDefaultsManager.libraryBookmarkData==nil{
    
    guard let sharedLibraryBookmarkData = UserDefaultsManager.sharedLibraryBookmarkData else {
        fatalError()
    }
    
    do{
        var isStale = false
        let resolvedURL = try URL(resolvingBookmarkData: sharedLibraryBookmarkData, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
        UserDefaultsManager.libraryBookmarkData = try resolvedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
    }catch{
        print("Error creating security-scoped bookmark: \(error.localizedDescription)")
    }
}

guard let db = DatabaseManager() else {
    exit(1)
}

do {
    // Resolve library bookmark data to URL

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

