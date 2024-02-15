//
//  DiskAccessManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-14.
//

import Foundation

class DiskAccessManager {
    public static var userAuthorizedDiskAccess: Bool {
        //determine disk access by checking whether we can access chat.db
        return UserDefaultsManager.libraryBookmarkData != nil
    }
    
    public static var chatDBURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard libraryBookmarkDataURL.startAccessingSecurityScopedResource() else {
                fatalError("Could not access messagesBookmarkDataURL")
            }
            
            libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
            
            return libraryBookmarkDataURL.appending(path: "Messages/chat.db")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var autoSpotoURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard libraryBookmarkDataURL.startAccessingSecurityScopedResource() else {
                fatalError("Could not access messagesBookmarkDataURL")
            }
            
            libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
            
            return libraryBookmarkDataURL.appending(path: "Application Support/AutoSpoto")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var autoSpotoDBURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard libraryBookmarkDataURL.startAccessingSecurityScopedResource() else {
                fatalError("Could not access libraryBookmarkDataURL")
            }
            
            libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
            
            return libraryBookmarkDataURL.appending(path: "Application Support/AutoSpoto/autospoto.db")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var spotifyTokenURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard libraryBookmarkDataURL.startAccessingSecurityScopedResource() else {
                fatalError("Could not access libraryBookmarkDataURL")
            }
            
            libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
            
            return libraryBookmarkDataURL.appending(path: "Application Support/AutoSpoto/spotifyToken.json")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var licenseURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard libraryBookmarkDataURL.startAccessingSecurityScopedResource() else {
                fatalError("Could not access libraryBookmarkDataURL")
            }
            
            libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
            
            return libraryBookmarkDataURL.appending(path: "Application Support/AutoSpoto/license.json")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var playlistUpdaterValidationURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard libraryBookmarkDataURL.startAccessingSecurityScopedResource() else {
                fatalError("Could not access libraryBookmarkDataURL")
            }
            
            libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
            
            return libraryBookmarkDataURL.appending(path: "Application Support/AutoSpoto/PlaylistUpdaterValidation.json")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var imageFilePathsURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard libraryBookmarkDataURL.startAccessingSecurityScopedResource() else {
                fatalError("Could not access messagesBookmarkDataURL")
            }
            
            libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
            
            return libraryBookmarkDataURL.appending(path: "Intents/Images")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
}
