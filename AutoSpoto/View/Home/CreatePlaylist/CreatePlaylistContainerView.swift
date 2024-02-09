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
    
    @State private var canCreatePlaylist: Bool = false //true if user has a license or they haven't used their free playlist unlock
    
    var body: some View {
        ZStack {
            if canCreatePlaylist {
                CreatePlaylistView(showCreatePlaylistSheet: $showCreatePlaylistSheet, chat: chat)
            } else {
                AutoSpotoProUpgradeView(showCreatePlaylistSheet: $showCreatePlaylistSheet)
            }
        }
        .onAppear {
            guard UserDefaultsManager.userHasTrackedChat else {
                //user has not created any chats yet
                canCreatePlaylist = true
                return
            }
            
            canCreatePlaylist = homeViewModel.isAutoSpotoPro
        }
    }
}
