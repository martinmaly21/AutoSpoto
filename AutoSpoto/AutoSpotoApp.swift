//
//  AutoSpotoApp.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

@main
struct AutoSpotoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    enum CurrentView {
        case onboarding
        case home
    }
    
    @State private var autoSpotoCurrentView: CurrentView = .onboarding
    @State private var showAutoSpotoDisconnectSheet: Bool = false
    @State private var helpOpened = false

    var body: some Scene {
        WindowGroup {
            VStack {
                switch autoSpotoCurrentView {
                case .onboarding:
                    OnboardingContainerView(autoSpotoCurrentView: $autoSpotoCurrentView)
                case .home:
                    HomeContainerView()
                }
            }
            .preferredColorScheme(.dark)
            .sheet(
                isPresented: $showAutoSpotoDisconnectSheet,
                content: {
                    AutoSpotoDisconnectView(isVisible: $showAutoSpotoDisconnectSheet, autoSpotoCurrentView: $autoSpotoCurrentView)
                }
            )
            .onAppear {
                PlaylistUpdaterManager.registerIfNeeded()
                
                //Make sure user has logged into Spotify and has given Disk Access before showing them home view
                if SpotifyTokenManager.authenticationTokenExists && DiskAccessManager.userAuthorizedDiskAccess {
                    //user has previously logged in
                    //we will assume Spotify profile exists too, since it's set at same time
                    autoSpotoCurrentView = .home
                } else {
                    //otherwise, show user onboarding
                    autoSpotoCurrentView = .onboarding
                }
            }
        }
        .commands {
            CommandGroup(before: CommandGroupPlacement.appTermination, addition: {
                Button(AutoSpotoConstants.Strings.DISCONNECT_AUTOSPOTO) {
                    showAutoSpotoDisconnectSheet = true
                }
            })
            CommandGroup(replacing: CommandGroupPlacement.newItem) { }
            
            CommandGroup(replacing: .help) {
                Button(action: {
                    if !helpOpened {
                        helpOpened.toggle()
                        HelpView(isOpen: $helpOpened).openNewWindow(with: "Help")
                    }
                }, label: {
                    Text(AutoSpotoConstants.Strings.CONTACT_AUTOSPOTO)
                })
                .keyboardShortcut("/")
            }
        }
        //disable resizing of the window
        .windowResizability(.contentSize)
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
