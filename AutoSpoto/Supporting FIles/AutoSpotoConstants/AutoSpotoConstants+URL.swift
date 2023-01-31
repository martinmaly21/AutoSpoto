//
//  AutoSpotoConstants+URL.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import Foundation

extension AutoSpotoConstants {
    struct URL {
        private init() {}
    }
}

extension AutoSpotoConstants.URL {
    static let fullDiskAccess = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
}
