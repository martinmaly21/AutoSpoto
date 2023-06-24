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
        FirebaseApp.configure()
    }
}
