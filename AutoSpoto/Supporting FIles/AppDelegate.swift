//
//  AppDelegate.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-24.
//

import AppKit
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // on macOS, AppKit catches the exceptions thrown on the main thread to prevent the application from crashing.
        // But this also prevents Crashlytics from catching them. To disable this behavior we have to set a special user
        // default before initializing Crashlytic
        UserDefaults.standard.register(
            defaults: [
                "NSApplicationCrashOnExceptions" : true,
                AutoSpotoConstants.UserDefaults.userHasTrackedChats : false
            ]
        )
        
        FirebaseApp.configure()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
