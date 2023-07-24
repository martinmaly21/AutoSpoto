//
//  CreatePlaylistContainerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI

struct CreatePlaylistContainerView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    @Binding var showCreatePlaylistSheet: Bool
    let chat: Chat
    
    @State private var isCheckingLicense: Bool = true
    @State private var canCreatePlaylist: Bool = false //true if user has a license or they haven't used their free playlist unlock
    
    var body: some View {
        ZStack {
            if isCheckingLicense {
                ProgressView()
            } else if canCreatePlaylist {
                CreatePlaylistView(showCreatePlaylistSheet: $showCreatePlaylistSheet, chat: chat)
            } else {
                AutoSpotoProUpgradeView()
            }
        }
        .frame(width: 450, height: 275)
        .padding(.all, 25)
        .onAppear {
            guard DatabaseManager.hasTrackedChats {
                //user has not created any chats yet
                canCreatePlaylist = true
                isCheckingLicense = false
                return
            }
            
            Task {
                guard let licenseKey = LicenseManager.licenseKey else {
                    canCreatePlaylist = false
                    isCheckingLicense = false
                    return
                }
                
                canCreatePlaylist = await GumroadManager.verify(licenseKey: licenseKey)
                isCheckingLicense = false
            }
        }
    }
}
