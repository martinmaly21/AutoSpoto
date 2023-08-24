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
    enum CurrentView {
        case onboarding
        case home
    }
    
    @State private var autoSpotoCurrentView: CurrentView = .onboarding
    @State private var showAutoSpotoDisconnectSheet: Bool = false
    
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            AutoSpotoContainerView(autoSpotoCurrentView: $autoSpotoCurrentView)
                .preferredColorScheme(.dark)
                .sheet(
                    isPresented: $showAutoSpotoDisconnectSheet,
                    content: {
                        AutoSpotoDisconnectView(isVisible: $showAutoSpotoDisconnectSheet, autoSpotoCurrentView: $autoSpotoCurrentView)
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
