//
//  PlaylistUpdaterManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-08-24.
//

import Foundation
import ServiceManagement

class PlaylistUpdaterManager {
    public static func registerIfNeeded() {
        Task.detached(priority: .background) {
            let service = SMAppService.agent(plistName: "com.autospoto.app.playlistupdater.plist")
            
            if service.status == .notFound || service.status == .notRegistered {
                do {
                    try service.register()
                    print("Successfully registered \(service)")
                } catch {
                    print("Unable to register \(error)")
                }
            }
        }
    }
    
    public static func deregisterIfNeeded() {
        Task.detached(priority: .background) {
            let service = SMAppService.agent(plistName: "com.autospoto.app.playlistupdater.plist")
            
            if service.status == .enabled {
                do {
                    try service.unregister()
                    print("Successfully registered \(service)")
                } catch {
                    print("Unable to register \(error)")
                }
            }
        }
    }
    
    public static func deletePlaylistUpdaterValidation() {
        let fileManager = FileManager.default
        if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            do {
                let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto")
                try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                let playlistUpdaterValidationURL = directoryURL.appendingPathComponent("PlaylistUpdaterValidation.json")
                
                try fileManager.removeItem(at: playlistUpdaterValidationURL)
            } catch let error {
                print("Error deleting PlaylistUpdaterValidation: \(error.localizedDescription)")
            }
        }
    }
}
