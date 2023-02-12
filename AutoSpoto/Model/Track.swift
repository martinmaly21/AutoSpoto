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
    var timeStamp: Int

    var hasFetchedMetadata = false
    var isFetchingMetadata = false
    var errorFetchingMetadata = false

    var imageURL: URL?
    var title: String?
    var artist: String?

    init(url: URL, timeStamp: Int) {
        self.url = url
        self.timeStamp = timeStamp
    }

    public func getTrackMetadata(
        completion: @escaping (Track) -> Void
    ) {
        defer {
            isFetchingMetadata = false
        }

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
                    completion(self)
                case .success(let og):
                    if let imageURLString = og[.image] {
                        self.imageURL = URL(string: imageURLString)
                    }

                    self.title = og[.title]
                    self.artist = og[.description]
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
