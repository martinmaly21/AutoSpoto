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
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            return libraryBookmarkDataURL.appending(path: "chat.db")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var autoSpotoURL: URL? {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory.appending(path: "AutoSpoto")
    }
    
    public static var autoSpotoDBURL: URL? {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory.appending(path: "AutoSpoto/autospoto.db")
    }
    
    public static var spotifyTokenURL: URL? {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory.appending(path: "AutoSpoto/spotifyToken.json")
    }
    
    public static var licenseURL: URL? {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory.appending(path: "AutoSpoto/license.json")
    }
    
    public static var playlistUpdaterValidationURL: URL? {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory.appending(path: "AutoSpoto/PlaylistUpdaterValidation.json")
    }
    
    public static var imageFilePathsURL: URL? {
        //TODO: figure out how to handle group chat photos not existing
        return nil
    }
    
    public static func startAccessingSecurityScopedResource() {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            let _ = libraryBookmarkDataURL.startAccessingSecurityScopedResource()
        } catch let error {
            return
        }
    }
    
    public static func stopAccessingSecurityScopedResource() {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            let _ = libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
        } catch let error {
            return
        }
    }
}
