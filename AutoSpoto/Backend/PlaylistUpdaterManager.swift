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
            let service = SMAppService.agent(plistName: "com.autospoto.app.playlistupdaterhelper.plist")
            
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
            let service = SMAppService.agent(plistName: "com.autospoto.app.playlistupdaterhelper.plist")
            
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
        do {
            if let playlistUpdaterValidationURL = DiskAccessManager.playlistUpdaterValidationURL {
                DiskAccessManager.startAccessingSecurityScopedResource()
                try FileManager.default.removeItem(at: playlistUpdaterValidationURL)
                DiskAccessManager.stopAccessingSecurityScopedResource()
            }
        } catch let error {
            print("Error deleting PlaylistUpdaterValidation: \(error.localizedDescription)")
        }
    }
}
