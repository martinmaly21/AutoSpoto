//
//  Track.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-11.
//

import Foundation

class Track: Hashable {
    var url: URL
    var timeStamp: String

    var imageURL: URL?
    var title: String?
    var artist: String?

    init?(trackCodable: TrackCodable) {
        let trackID = trackCodable.track_id
        guard let url = URL(string: "https://open.spotify.com/track/\(trackID)") else {
            assertionFailure("Could not get track URL")
            return nil
        }
        self.url = url
        self.timeStamp = trackCodable.date_utc
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(timeStamp)

        hasher.combine(imageURL)
        hasher.combine(title)
        hasher.combine(artist)
    }

    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
}
