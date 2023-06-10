//
//  AutoSpotoConstants+Limits.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-10.
//

import Foundation

extension AutoSpotoConstants {
    struct Limits {
        private init() {}
    }
}

extension AutoSpotoConstants.Limits {
    static let maximumNumberOfSpotifyTracksPerMetadataFetchCall = 50
    static let maximumNumberOfSpotifyTracksPerAddToPlaylistCall = 100
}
