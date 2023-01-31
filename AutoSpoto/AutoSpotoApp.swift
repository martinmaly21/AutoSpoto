//
//  AutoSpotoApp.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

@main
struct AutoSpotoApp: App {
    var body: some Scene {
        WindowGroup {
            //TODO: check if user has went through "Onboarding" process
            //IF so, show messages UI
            //If not, show OnboardingContainerView

            OnboardingContainerView()
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
        //disable resizing of the window
        .windowResizability(.contentSize)
    }
}
