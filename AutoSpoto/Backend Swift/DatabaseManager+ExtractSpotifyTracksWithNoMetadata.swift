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
        for chatIDs: [Int],
        after lastUpdatedDate: Date = Date(timeIntervalSince1970: 0) //if no explicit parameter is passed in for lastUpdatedDate, we will fetch all trackIDs after 1970. So, all of them ever.
    ) async -> [Track] {
        //TODO: extract given chatIDs
        var tracks: [Track] = []
        chatIDs.forEach{selectedChatIDs in
            tracks += ExctractScript().FetchChats(from:selectedChatIDs)
        }
        
        //remove duplicates
        tracks = tracks.unique
        
        return tracks
    }
}


