//
//  AutoSpotoConstants+Regex.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-03-17.
//

import Foundation

extension AutoSpotoConstants {
    struct Regex {
        private init() {}
    }
}


extension AutoSpotoConstants.Regex {
    static let spotifyTrackIDRegex = "([0-9a-zA-Z]{22})"
}
