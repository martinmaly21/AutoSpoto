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

    enum MetaDataFetchError {
        case miscError
        case error404
    }
    var errorFetchingMetadata: MetaDataFetchError?

    var imageURL: URL?
    var title: String?
    var artist: String?

    private var currentTask: URLSessionDataTask?

    init?(trackCodable: TrackCodable) {
        guard let url = URL(string: trackCodable.decoded_blob) else {
            assertionFailure("Could not create URL")
            return nil
        }
        self.url = url
        self.timeStamp = trackCodable.date_utc
    }

    public func fetchTrackMetadata(
        completion: @escaping (Track) -> Void
    ) {
        guard !hasFetchedMetadata && !isFetchingMetadata else { return }

        isFetchingMetadata = true
        hasFetchedMetadata = true

        let task = OpenGraph.fetch(
            url: url,
            completion: { result in
                self.currentTask = nil

                switch result {
                case .failure(let error):

                    if let error = error as? OpenGraphResponseError,
                       case .unexpectedStatusCode(404) = error {
                        //404 error (invalid url)
                        self.errorFetchingMetadata = .error404
                        self.hasFetchedMetadata = true
                    } else {
                        //otherwise, fetch was cancelled or perhaps too many network requests. Either way, we can
                        //try to fetch again next time the cell appears
                        self.hasFetchedMetadata = false
                    }

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

        if let currentTask = currentTask {
            currentTask.cancel()
        }

        self.currentTask = task
    }

    public func cancelTaskIfNeeded() {
        currentTask?.cancel()
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
