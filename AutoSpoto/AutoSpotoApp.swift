//
//  AutoSpotoApp.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

@main
struct AutoSpotoApp: App {
    let testingHomeView = true

    var body: some Scene {
        WindowGroup {
            //TODO: check if user has went through "Onboarding" process

            //TODO: check if user has granted disk access. if so:

            //IF so, check if user has logged in to streaming service
            //if yes, bring them to main app screen

            //IF not, show stream service shit

            //if no disk access, show them splash screen again


            //IF so, show messages UI
            //If not, show OnboardingContainerView

            if testingHomeView {
                HomeContainerView()
            } else {
                AndrewsBackendTestView()
                    .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                        for window in NSApplication.shared.windows {
                            //hide title bar
                            window.titlebarAppearsTransparent = true
                            window.titleVisibility = .hidden

                            //hide minimize (yellow) and expand (green) buttons
                            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                            window.standardWindowButton(.zoomButton)?.isHidden = true
                        }
                    })
            }
        }
        //disable resizing of the window
        .windowResizability(.contentSize)
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
