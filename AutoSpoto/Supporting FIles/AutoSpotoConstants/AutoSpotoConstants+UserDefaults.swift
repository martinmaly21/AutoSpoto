//
//  AutoSpotoConstants+UserDefaults.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

extension AutoSpotoConstants {
    struct UserDefaults {
        private init() {}
    }
}

extension AutoSpotoConstants.UserDefaults {
    static let spotifyUser = "spotifyUser"
    static let userHasTrackedChats = "userHasTrackedChats"
    static let addressBookID = "addressBookID"
    static let messagesBookmarkData = "messagesBookmarkData"
}
