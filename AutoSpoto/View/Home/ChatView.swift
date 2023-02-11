//
//  ChatView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    @Binding var selectedChat: Chat?

    var body: some View {
        if let selectedChat = selectedChat {
            ScrollView {
                VStack {
                    ForEach(selectedChat.tracks, id: \.self) { url in
                        TrackRow(track: url)
                    }
                }
            }
        } else {
            ProgressView()
        }
    }
}
