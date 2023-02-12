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
        }
        .environmentObject(homeViewModel)
        .onAppear {
            homeViewModel.fetchChats()
        }
        .onChange(
            of: homeViewModel.selectedChat,
            perform: { _ in
                if let selectedChat = homeViewModel.selectedChat {
                    Task {
                        await homeViewModel.fetchTracks(for: selectedChat)
                    }
                }
            }
        )
        .introspectSplitView { controller in
            (controller.delegate as? NSSplitViewController)?.splitViewItems.first?.canCollapse = false
        }
    }
}
