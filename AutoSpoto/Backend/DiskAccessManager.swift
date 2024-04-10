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
        //
        return UserDefaultsManager.libraryBookmarkData != nil
    }
    
    public static var chatDBURL: URL? {
        guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
            return nil
        }
        
        do {
            var isStale = false
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            return libraryBookmarkDataURL.appending(path: "chat.db")
        } catch let error {
            fatalError("Could not access in chatDBURL getter: \(error.localizedDescription)")
        }
    }
    
    public static var autoSpotoURL: URL? {
        guard let groupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AutoSpotoConstants.UserDefaults.group_name) else {
            return nil
        }
        return groupContainerURL.appendingPathComponent("AutoSpoto")
    }

    public static var autoSpotoDBURL: URL? {
        guard let groupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AutoSpotoConstants.UserDefaults.group_name) else {
            return nil
        }
        return groupContainerURL.appendingPathComponent("AutoSpoto/autospoto.db")
    }

    public static var spotifyTokenURL: URL? {
        guard let groupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AutoSpotoConstants.UserDefaults.group_name) else {
            return nil
        }
        return groupContainerURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
    }

    public static var licenseURL: URL? {
        guard let groupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AutoSpotoConstants.UserDefaults.group_name) else {
            return nil
        }
        return groupContainerURL.appendingPathComponent("AutoSpoto/license.json")
    }

    public static var playlistUpdaterValidationURL: URL? {
        guard let groupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AutoSpotoConstants.UserDefaults.group_name) else {
            return nil
        }
        return groupContainerURL.appendingPathComponent("AutoSpoto/PlaylistUpdaterValidation.json")
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
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
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
            let libraryBookmarkDataURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            let _ = libraryBookmarkDataURL.stopAccessingSecurityScopedResource()
        } catch let error {
            return
        }
    }
    
    public static func checkSharedGroupContainer() {
        if UserDefaultsManager.sharedLibraryBookmarkData == nil {
            guard let libraryBookmarkData = UserDefaultsManager.libraryBookmarkData else {
                return
            }
            
            do {
                var isStale = false
                let resolvedURL = try URL(resolvingBookmarkData: libraryBookmarkData, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
                UserDefaultsManager.sharedLibraryBookmarkData = try resolvedURL.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)
            } catch {
                print("Error creating app group container bookmark: \(error.localizedDescription)")
                return
            }
        }
    }
}
