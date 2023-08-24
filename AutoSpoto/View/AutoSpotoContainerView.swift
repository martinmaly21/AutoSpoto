//
//  AutoSpotoContainerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import SwiftUI

struct AutoSpotoContainerView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Binding var autoSpotoCurrentView: AutoSpotoApp.CurrentView
    
    var body: some View {
        ZStack {
            switch autoSpotoCurrentView {
            case .onboarding:
                OnboardingContainerView(autoSpotoCurrentView: $autoSpotoCurrentView)
            case .home:
                HomeContainerView()
                    .onAppear {
                        PlaylistUpdaterManager.registerIfNeeded()
                    }
            }
        }
        .onAppear {
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
}
