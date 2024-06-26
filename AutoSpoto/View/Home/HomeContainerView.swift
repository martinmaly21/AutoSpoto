//
//  HomeContainerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct HomeContainerView: View {
    @StateObject var homeViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ChatsListView()
            ChatView()
                .frame(minWidth: 600)
        }
        .environmentObject(homeViewModel)
        .onAppear {
            Task {
                DiskAccessManager.checkSharedGroupContainer()
                await homeViewModel.fetchChats()
                PlaylistUpdaterManager.registerIfNeeded()
            }
        }
    }
}
