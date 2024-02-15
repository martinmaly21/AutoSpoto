//
//  UserDefaultsManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

class UserDefaultsManager {
    static var spotifyUser: SpotifyUser {
        get {
            guard let spotifyUserData = UserDefaults.standard.object(
                forKey: AutoSpotoConstants.UserDefaults.spotifyUser
            ) as? Data,
                  let spotifyUser = try? JSONDecoder().decode(
                    SpotifyUser.self, from: spotifyUserData
                  ) else {
                fatalError("Could not get spotifyUserData")
            }
            
            return spotifyUser
        }
        
        set {
            guard let encodedSpotifyUserData = try? JSONEncoder().encode(newValue) else {
                fatalError("Could not encode spotify user")
            }
            UserDefaults.standard.set(
                encodedSpotifyUserData,
                forKey: AutoSpotoConstants.UserDefaults.spotifyUser
            )
        }
    }
    
    static var userHasTrackedChat: Bool {
        get {
            let userHasTrackedChat = UserDefaults.standard.bool(
                forKey: AutoSpotoConstants.UserDefaults.userHasTrackedChats
            )
            
            return userHasTrackedChat
        }
        
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: AutoSpotoConstants.UserDefaults.userHasTrackedChats
            )
        }
    }
    
    static var messagesBookmarkData: Data? {
        get {
            guard let messagesBookmarkData = UserDefaults.standard.data(
                forKey: AutoSpotoConstants.UserDefaults.messagesBookmarkData
            ) else {
                return nil
            }
            
            do {
                let _ = try URL(resolvingBookmarkData: messagesBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                
                if isStale {
                    return nil
                } else {
                    return messagesBookmarkData
                }
            } catch let error {
                return nil
            }
        }
        
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: AutoSpotoConstants.UserDefaults.messagesBookmarkData
            )
        }
    }
}
