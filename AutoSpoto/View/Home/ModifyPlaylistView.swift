//
//  ModifyPlaylistView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-11.
//

import SwiftUI
import Kingfisher

struct ModifyPlaylistView: View {
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showModifyPlaylistSheet: Bool
    @State private var optInToAutomaticPlaylistUpdates = true
    @State private var disconnectedChatFromPlaylist = false
    
    let chat: Chat
    
    var spotifyPlaylist: SpotifyPlaylist {
        guard let playlist = chat.spotifyPlaylist else {
            fatalError("Could not get SpotifyPlaylist")
        }
        
        return playlist
    }
    
    init(
        showModifyPlaylistSheet: Binding<Bool>,
        chat: Chat
    ) {
        self._showModifyPlaylistSheet = showModifyPlaylistSheet
        self.chat = chat
    }
    
    var body: some View {
        VStack {
            if disconnectedChatFromPlaylist {
                
            } else {
                HStack {
                    Text(String.localizedStringWithFormat(AutoSpotoConstants.Strings.MODIFY_PLAYLIST_WITH_NAME, spotifyPlaylist.name))
                            .font(.josefinSansBold(22))
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    KFImage(chat.spotifyPlaylist?.imageURL)
                        .placeholder {
                            Image("spotify-logo")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.spotifyGreen)
                                .frame(width: 40, height: 40)
                        }
                        .cacheOriginalImage(true)
                        .fade(duration: 0.25)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                        .aspectRatio(contentMode: .fill)
                }
                
                VStack(spacing: 25){
                    HStack {
                        //TODO: BUTTON
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
//                    Toggle(
//                        isOn: $optInToAutomaticPlaylistUpdates,
//                        label: {
//                            Text(String.localizedStringWithFormat(chat.isGroupChat ? AutoSpotoConstants.Strings.AUTOMATIC_PLAYLIST_UPDATES_GROUP_CHAT : AutoSpotoConstants.Strings.AUTOMATIC_PLAYLIST_UPDATES_SINGLE_CHAT, chat.displayName))
//                                .font(.josefinSansRegular(16))
//                        }
//                    )
                    
                    
//                    Button(
//                        action: {
//                            Task {
//                                await homeViewModel.disconnectPlaylist(for: chat)
//                                disconnectedChatFromPlaylist = true
//                            }
//                        },
//                        label: {
//                            Text(AutoSpotoConstants.Strings.SYNC_TRACKS)
//                                .font(.josefinSansRegular(15))
//                                .foregroundColor(.primaryBlue)
//                                .underline(pattern: .solid)
//
//                        }
//                    )
//                    .buttonStyle(.plain)
                    
                    Button(
                        action: {
                            Task {
                                await homeViewModel.disconnectPlaylist(for: chat)
                                disconnectedChatFromPlaylist = true
                            }
                        },
                        label: {
                            Text(AutoSpotoConstants.Strings.DISCONNECT_CHAT_FROM_PLAYLIST)
                                .font(.josefinSansRegular(15))
                                .foregroundColor(.errorRed)
                                .underline(pattern: .solid)
                            
                        }
                    )
                    .buttonStyle(.plain)
                    
                }
                
                Spacer()
            }
        }
        .frame(width: 450)
        .padding(.all, 25)
    }
}
