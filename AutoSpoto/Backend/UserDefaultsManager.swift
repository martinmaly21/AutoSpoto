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
    
        static var libraryBookmarkData: Data? {
            get {
                let group_name = "TODO_UPDATE_TEAM_ID.app.dependencies.dependencies.preferences"
                guard let libraryBookmarkData = UserDefaults(suiteName: group_name)?.data(
                        forKey: AutoSpotoConstants.UserDefaults.libraryBookmarkData
                ) else {
                    return nil
                }
                
                do {
                    var isStale = false
                    let url = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                    if isStale {
                        return nil
                    } else {
                        return libraryBookmarkData
                    }
                } catch let error {
                    return nil
                }
            }
            
            set {
                let group_name = "TODO_UPDATE_TEAM_ID.app.dependencies.dependencies.preferences"
                UserDefaults(suiteName: group_name)?.set(
                    newValue,
                    forKey: AutoSpotoConstants.UserDefaults.libraryBookmarkData
                )
            }
        }

}
