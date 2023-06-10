//
//  CreatePlaylistView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct CreatePlaylistView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showCreatePlaylistSheet: Bool
    
    let chat: Chat
    
    @State private var playlistName: String
    @State private var optInToAutomaticPlaylistUpdates = true
    
    init(
        showCreatePlaylistSheet: Binding<Bool>,
        chat: Chat
    ) {
        self._showCreatePlaylistSheet = showCreatePlaylistSheet
        self.chat = chat
        _playlistName = State(initialValue: chat.displayName)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(AutoSpotoConstants.Strings.ENTER_PLAYLIST_DETAILS)
                    .font(.josefinSansBold(22))
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Image("spotify-logo")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.textPrimaryWhite)
                    .frame(width: 30, height: 30)
            }
            
            
            VStack(alignment: .leading, spacing: 6) {
                Text(AutoSpotoConstants.Strings.ENTER_PLAYLIST_NAME)
                    .font(.josefinSansRegular(18))
                
                TextField(AutoSpotoConstants.Strings.PLAYLIST_PLACEHOLDER_NAME, text: $playlistName)
                    .font(.josefinSansRegular(18))
            }
            .padding(.vertical)
            Toggle(
                isOn: $optInToAutomaticPlaylistUpdates,
                label: {
                    Text(String.localizedStringWithFormat(chat.isGroupChat ? AutoSpotoConstants.Strings.AUTOMATIC_PLAYLIST_UPDATES_GROUP_CHAT : AutoSpotoConstants.Strings.AUTOMATIC_PLAYLIST_UPDATES_SINGLE_CHAT, chat.displayName))
                        .font(.josefinSansRegular(16))
                        .frame(height: 50)
                }
            )
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        self.showCreatePlaylistSheet = false
                    },
                    label: {
                        Text(AutoSpotoConstants.Strings.CANCEL)
                    }
                )
                .padding(.leading, 8)
                
                Button(
                    action: {
                        Task {
                            await homeViewModel.createPlaylistAndAddSongs(
                                chat: chat,
                                desiredPlaylistName: playlistName
                            )
                            self.showCreatePlaylistSheet = false
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
        .frame(width: 450, height: 200)
        .padding(.all, 25)
    }
}
