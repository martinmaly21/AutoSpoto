//
//  Track.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-11.
//

import Foundation

class Track: Hashable {
    var url: URL
    var timeStamp: String?

    var imageURL: URL?
    var name: String?
    var artist: String?
    var album: String?
    var releaseYear: Int?
    var previewURL: URL? //mp3 preview of song

    init?(trackID: String) {
        guard let url = URL(string: "https://open.spotify.com/track/\(trackID)") else {
            assertionFailure("Could not get track URL")
            return nil
        }
        self.url = url
    }

    init?(longTrackCodable: LongTrackCodable) {
        let trackID = longTrackCodable.track_id
        guard let url = URL(string: "https://open.spotify.com/track/\(trackID)") else {
            assertionFailure("Could not get track URL")
            return nil
        }
        self.url = url
        self.timeStamp = longTrackCodable.date_utc

        if let imageURLString = longTrackCodable.image_ref {
            self.imageURL = URL(string: imageURLString)
        }

        self.name = longTrackCodable.song_name
        self.artist = longTrackCodable.artist_name
        self.album = longTrackCodable.album_name

        if let releaseYearString = longTrackCodable.release_year {
            self.releaseYear = Int(releaseYearString)
        }

        if let previewURLString = longTrackCodable.preview_url {
            self.previewURL = URL(string: previewURLString)
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
        hasher.combine(previewURL)
    }

    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
}
