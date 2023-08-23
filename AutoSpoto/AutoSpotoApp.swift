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
    @State private var showAutoSpotoDisconnectSheet: Bool = false
    
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            AutoSpotoContainerView()
                .preferredColorScheme(.dark)
                .sheet(
                    isPresented: $showAutoSpotoDisconnectSheet,
                    content: {
                        Text("SLDFS")
                    }
                )
        }
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: updaterController.updater)
            }
            
            
            CommandGroup(before: CommandGroupPlacement.appTermination, addition: {
                Button(AutoSpotoConstants.Strings.DISCONNECT_AUTOSPOTO) {
                    showAutoSpotoDisconnectSheet = true
                }
            })
            CommandGroup(replacing: CommandGroupPlacement.newItem) { }
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
