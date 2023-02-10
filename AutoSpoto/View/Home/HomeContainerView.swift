//
//  HomeContainerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct HomeContainerView: View {
    @StateObject var homeViewModel = HomeViewModel()

    @State private var selectedChat: Chat?

    var body: some View {
        NavigationView {
            ChatsListView(
                chats: homeViewModel.chats,
                selectedChat: $selectedChat
            )

            ChatView(selectedChat: $selectedChat)
        }
        .onAppear {
            homeViewModel.fetchChats()
            selectedChat = homeViewModel.chats.first
        }
        .onChange(
            of: selectedChat,
            perform: { _ in
                if let selectedChat = selectedChat {
                    homeViewModel.fetchTracks(for: selectedChat)
                }
            }
        )
        .introspectSplitView { controller in
            (controller.delegate as? NSSplitViewController)?.splitViewItems.first?.canCollapse = false
        }
    }
}
