//
//  DatabaseManager+ExtractSpotifyTracksWithNoMetadata.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

//MARK: - this extension is for extracting the Spotify Track id's from a given chat
extension DatabaseManager {
    func fetchSpotifyTracksWithNoMetadata(
        for chatIDs: [Int]
    ) async -> [Track] {
        var tracks: [Track] = []
        chatIDs.forEach{selectedChatIDs in
            tracks += ExtractScript().fetchSongsFromChats(from:selectedChatIDs)
        }
        //remove duplicates
        tracks = tracks.unique
        
        return tracks
    }
}


