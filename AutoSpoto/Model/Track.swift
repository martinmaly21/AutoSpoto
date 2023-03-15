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

    var hasFetchedMetadata = false
    var isFetchingMetadata = false

    enum MetaDataFetchError {
        case miscError
        case error404
    }
    var errorFetchingMetadata: MetaDataFetchError?

    var imageURL: URL?
    var title: String?
    var artist: String?

    init?(trackCodable: TrackCodable) {
        guard let url = URL(string: trackCodable.decoded_blob) else {
            assertionFailure("Could not create URL")
            return nil
        }
        self.url = url
        self.timeStamp = trackCodable.date_utc
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(timeStamp)

        hasher.combine(hasFetchedMetadata)
        hasher.combine(isFetchingMetadata)
        hasher.combine(errorFetchingMetadata)

        hasher.combine(imageURL)
        hasher.combine(title)
        hasher.combine(artist)
    }

    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
}
