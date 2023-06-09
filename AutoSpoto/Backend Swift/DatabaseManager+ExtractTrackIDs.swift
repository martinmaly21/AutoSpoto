//
//  DatabaseManager+ExtractTrackIDs.swift
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
        return [
          Track(spotifyID: "3CeKc83EsgRPItgvlDHo5B", timeStamp: "BLAH"),
          Track(spotifyID: "6YNSajixFoJriODKAsyFAr", timeStamp: "BLAH"),
          Track(spotifyID: "2EGaDf0cPX789H3LNeB03D", timeStamp: "BLAH"),
          Track(spotifyID: "2bY6J7raCWuUACZ9pPd5fY", timeStamp: "BLAH"),
          Track(spotifyID: "2bY6J7raCWuUACZ9pld5fY", timeStamp: "BLAH")
        ]
    }
}
