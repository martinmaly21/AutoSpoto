//
//  Track.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-11.
//

import Foundation

class Track: Equatable, Identifiable, Comparable {
    let spotifyID: String
    let timeStamp: Date //time stamp for when song was sent

    var imageURL: URL?
    var name: String?
    var artist: String?
    
    var metadataHasBeenFetched = false
    var errorFetchingTrackMetadata = false
    
    var url: URL {
        guard let url = URL(string: "https://open.spotify.com/track/\(spotifyID)") else {
            fatalError("Could not get track URL")
        }
        return url
    }

    init(spotifyID: String, timeStamp: Date) {
        self.spotifyID = spotifyID
        self.timeStamp = timeStamp
    }

    //we need to also pass in trackID, because it won't be passed back from spotify API if it's invalid
    convenience init(longTrackCodable: SpotifyTracksResponse.SpotifyTrack?, existingTrack: Track) {
        self.init(spotifyID: existingTrack.spotifyID, timeStamp: existingTrack.timeStamp)
        
        metadataHasBeenFetched = true
        guard let longTrackCodable else {
            errorFetchingTrackMetadata = true
            return
        }

        self.imageURL = longTrackCodable.imageURL
        self.name = longTrackCodable.name
        self.artist = longTrackCodable.artistName
    }

    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.url == rhs.url
    }
    
    static func < (lhs: Track, rhs: Track) -> Bool {
        return lhs.timeStamp < rhs.timeStamp
    }
}
