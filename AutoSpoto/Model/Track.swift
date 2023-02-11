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

    public func getTrackMetadata() async {
        do {
            guard !hasFetchedMetadata && !isFetchingMetadata else { return }

            isFetchingMetadata = true
            hasFetchedMetadata = true

            let og = try await OpenGraph.fetch(url: url)

            isFetchingMetadata = false

            if let imageURLString = og[.image] {
                imageURL = URL(string: imageURLString)
            }

            title = og[.title]
            artist = og[.description]
        } catch let error {
            print("Error: \(error)")
            isFetchingMetadata = false
            errorFetchingMetadata = true
        }
    }

    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.url.absoluteString == rhs.url.absoluteString
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url.absoluteString)
    }
}