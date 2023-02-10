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
            ChatsListView(chats: homeViewModel.chats)

            ChatView()
        }
        .onAppear {
            homeViewModel.fetchChats()
        }
        .introspectSplitView { controller in
            (controller.delegate as? NSSplitViewController)?.splitViewItems.first?.canCollapse = false
        }
    }
}
