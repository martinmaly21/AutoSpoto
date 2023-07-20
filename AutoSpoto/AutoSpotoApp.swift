//
//  AutoSpotoApp.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI
import Sparkle

@main
struct AutoSpotoApp: App {
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        
        //register for playlist updater
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
    
    var body: some Scene {
        WindowGroup {
            AutoSpotoContainerView()
                .preferredColorScheme(.dark)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: updaterController.updater)
            }
        }
        //disable resizing of the window
        .windowResizability(.contentSize)
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .windowStyle(HiddenTitleBarWindowStyle())
        
        Settings {
            UpdaterSettingsView(updater: updaterController.updater)
        }
    }
}
