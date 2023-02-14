//
//  Track.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-11.
//

import Foundation
import OpenGraph

class Track: Hashable {
    var url: URL
    var timeStamp: String

    var hasFetchedMetadata = false
    var isFetchingMetadata = false
    var errorFetchingMetadata = false

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

    public func getTrackMetadata(
        completion: @escaping (Track) -> Void
    ) {
        guard !hasFetchedMetadata && !isFetchingMetadata else { return }

        isFetchingMetadata = true
        hasFetchedMetadata = true

        OpenGraph.fetch(
            url: url,
            completion: { result in
                switch result {
                case .failure(let failure):
                    print("Error: \(failure.localizedDescription)")
                    self.errorFetchingMetadata = true
                    self.isFetchingMetadata = false

                    completion(self)
                case .success(let og):
                    if let imageURLString = og[.image] {
                        self.imageURL = URL(string: imageURLString)
                    }

                    self.title = og[.title]
                    self.artist = og[.description]
                    self.isFetchingMetadata = false

                    completion(self)
                }
            }
        )

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
