//
//  Track.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-11.
//

import Foundation

class Track: Hashable {
    let spotifyID: String
    let timeStamp: String //time stamp for when song was sent

    var imageURL: URL?
    var name: String?
    var artist: String?
    var album: String?
    var releaseYear: Int?
    
    var metadataHasBeenFetched = false
    var errorFetchingTrackMetadata = false
    
    var url: URL {
        guard let url = URL(string: "https://open.spotify.com/track/\(spotifyID)") else {
            fatalError("Could not get track URL")
        }
        return url
    }

    init(spotifyID: String, timeStamp: String) {
        self.spotifyID = spotifyID
        self.timeStamp = timeStamp
    }

    //we need to also pass in trackID, because it won't be passed back from spotify API if it's invalid
    convenience init(longTrackCodable: SpotifyTrack?, existingTrack: Track) {
        self.init(spotifyID: existingTrack.spotifyID, timeStamp: existingTrack.timeStamp)
        
        metadataHasBeenFetched = true
        guard let longTrackCodable else {
            errorFetchingTrackMetadata = true
            return
        }

        if let imageURLString = longTrackCodable.image_ref {
            self.imageURL = URL(string: imageURLString)
        }

        self.name = longTrackCodable.song_name
        self.artist = longTrackCodable.artist_name
        self.album = longTrackCodable.album_name

        if let releaseYearString = longTrackCodable.release_year {
            self.releaseYear = Int(releaseYearString)
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(timeStamp)

        hasher.combine(imageURL)
        hasher.combine(name)
        hasher.combine(artist)
        hasher.combine(album)
        hasher.combine(releaseYear)
        
        hasher.combine(errorFetchingTrackMetadata)
        hasher.combine(metadataHasBeenFetched)
    }

    static func == (lhs: Track, rhs: Track) -> Bool {
        //TODO: should i update this to take in other parameters?
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
}
