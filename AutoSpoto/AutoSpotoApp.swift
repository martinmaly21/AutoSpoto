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
            AutoSpotoContainerView()
        }
        //disable resizing of the window
        .windowResizability(.contentSize)
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
