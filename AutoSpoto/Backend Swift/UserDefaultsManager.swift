//
//  UserDefaultsManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

class UserDefaultsManager {
    private var spotifyUserID: String {
        get {
            guard let spotifyUserID = UserDefaults.standard.string(forKey: AutoSpotoConstants.UserDefaults.spotifyUserID) else {
                fatalError("spotifyUserID was nil")
            }
            return spotifyUserID
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: AutoSpotoConstants.UserDefaults.spotifyUserID)
        }
    }
}
