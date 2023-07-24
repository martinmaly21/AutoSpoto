//
//  AppDelegate.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-24.
//

import AppKit
import SwiftUI
import FirebaseCore
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // on macOS, AppKit catches the exceptions thrown on the main thread to prevent the application from crashing.
        // But this also prevents Crashlytics from catching them. To disable this behavior we have to set a special user
        // default before initializing Crashlytic
        UserDefaults.standard.register(
            defaults: ["NSApplicationCrashOnExceptions" : true]
        )
        
        FirebaseApp.configure()
        
        
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
}
