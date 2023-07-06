//
//  main.swift
//  testing
//
//  Created by Andrew Caravaggio on 2023-07-05.
//


let playlistsRowsTuple = DatabaseManager()!.schedulerRetrievePlaylists()

for playlistsRow in playlistsRowsTuple {
    
    let chatID = playlistsRow.0 ?? -1
    
    let individualChat = IndividualChatCodable(
    imageBlob: nil,
    contactInfo: "Scheduler",
    chatIDs: [chatID],
    firstName: nil,
    lastName: nil,
    spotifyPlaylistID: playlistsRow.1,
    lastUpdated: playlistsRow.2
    )

    let newChat = Chat(individualChat)
    try await SpotifyManager.updatePlaylist(for: newChat)
}
