//
//  ModifyPlaylistView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct ModifyPlaylistView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showModifyPlaylistSheeet: Bool

    let chat: Chat

    @State private var playlistName: String

    init(
        showModifyPlaylistSheeet: Binding<Bool>,
        chat: Chat
    ) {
        self._showModifyPlaylistSheeet = showModifyPlaylistSheeet
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

                Button(
                    action: {
                        Task {
                            //TODO: check if playlsit already exists before performing appropriate function
                            await homeViewModel.createPlaylistAndAddSongs(
                                chat: chat,
                                desiredPlaylistName: playlistName
                            )
                            self.showModifyPlaylistSheeet = false
                        }
                    },
                    label: {
                        Text(AutoSpotoConstants.Strings.CREATE)
                    }
                )
            }
        }
        .onAppear {
            playlistName = chat.displayName
        }
        .frame(width: 300, height: 200)
        .padding()
    }
}
