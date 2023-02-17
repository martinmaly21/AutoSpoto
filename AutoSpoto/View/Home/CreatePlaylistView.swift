//
//  CreatePlaylistView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct CreatePlaylistView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showCreatePlaylistSheeet: Bool

    let chat: Chat

    @State private var playlistName: String

    init(
        showCreatePlaylistSheeet: Binding<Bool>,
        chat: Chat
    ) {
        self._showCreatePlaylistSheeet = showCreatePlaylistSheeet
        self.chat = chat
        _playlistName = State(initialValue: chat.displayName)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(AutoSpotoConstants.Strings.ENTER_PLAYLIST_DETAILS)
                .font(.josefinSansRegular(18))
                .font(.headline)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading) {
                Text(AutoSpotoConstants.Strings.ENTER_PLAYLIST_NAME)
                    .font(.josefinSansRegular(18))

                TextField(AutoSpotoConstants.Strings.PLAYLIST_PLACEHOLDER_NAME, text: $playlistName)
                    .font(.josefinSansRegular(18))
            }
            .padding()

            HStack {
                Spacer()
                Button(AutoSpotoConstants.Strings.CREATE) {
                    Task {
                        let playlistID = SwiftPythonInterface.createPlaylistAndAddSongs(
                            playlistName: playlistName,
                            chatID: chat.id
                        )

                        homeViewModel.updateChatForPlaylist(chat: chat, playlistID: playlistID)
                    }

                    self.showCreatePlaylistSheeet = false
                }
                .customButton(foregroundColor: .primaryBlue, backgroundColor: .white)
            }
        }
        .onAppear {
            playlistName = chat.displayName
        }
        .frame(width: 300, height: 200)
        .padding()
    }
}
