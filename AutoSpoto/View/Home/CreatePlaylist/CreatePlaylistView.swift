//
//  CreatePlaylistView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI
import Kingfisher

struct CreatePlaylistView: View {
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showCreatePlaylistSheet: Bool
    
    let chat: Chat
    
    @State private var playlistName: String
    @State private var errorCreatingPlaylist = false
    @State private var successfullyCreatedPlaylist = false
    @State private var isCreatingPlaylist = false
    
    private var successSubtitle: String {
        return String.localizedStringWithFormat(
            chat.isGroupChat ? AutoSpotoConstants.Strings.SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_GROUP_CHAT :
                AutoSpotoConstants.Strings.SUCCESSFULLY_CREATED_PLAYLIST_SUBTITLE_INDIVIDUAL_CHAT,
            chat.displayName,
            playlistName
        )
    }
    
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
            if successfullyCreatedPlaylist {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(AutoSpotoConstants.Strings.SUCCESSFULLY_CREATED_PLAYLIST)
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
                            .aspectRatio(contentMode: .fill)
                    }
                    
                    VStack(spacing: 25){
                        HStack {
                            Text(successSubtitle)
                                .font(.josefinSansRegular(18))
                            
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            ZStack {
                                Button(
                                    action: {
                                        if let url = chat.spotifyPlaylist?.url {
                                            openURL(url)
                                        }
                                    },
                                    label: {
                                        Text(chat.spotifyPlaylist?.url?.absoluteString ?? AutoSpotoConstants.Strings.CHAT_URL_PLACEHOLDER)
                                            .font(.josefinSansRegular(15))
                                            .foregroundColor(.spotifyGreen)
                                            .underline(pattern: .solid)
                                        
                                    }
                                )
                                .buttonStyle(.plain)
                                .redacted(reason: chat.spotifyPlaylist?.url == nil ? .placeholder : [])
                                
                            }
                            .frame(height: 0)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        DoneButton(
                            action: {
                                self.showCreatePlaylistSheet = false
                            }
                        )
                        .padding(.leading, 8)
                    }
                }
            } else {
                HStack {
                    Text(AutoSpotoConstants.Strings.ENTER_PLAYLIST_DETAILS)
                        .font(.josefinSansBold(22))
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Image("spotify-logo")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.spotifyGreen)
                        .frame(width: 40, height: 40)
                }
                
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(AutoSpotoConstants.Strings.ENTER_PLAYLIST_NAME)
                        .font(.josefinSansRegular(18))
                    
                    TextField(AutoSpotoConstants.Strings.PLAYLIST_PLACEHOLDER_NAME, text: $playlistName)
                        .font(.josefinSansRegular(18))
                }
                .padding(.vertical, 8)
                
                if errorCreatingPlaylist {
                    Text(AutoSpotoConstants.Strings.ERROR_CREATING_PLAYLIST)
                        .font(.josefinSansRegular(16))
                        .foregroundColor(.red)
                }
                
                HStack {
                    Spacer()
                    
                    CancelButton(
                        action: {
                            self.showCreatePlaylistSheet = false
                        }
                    )
                    .padding(.leading, 8)
                    
                    CreateButton(
                        action: {
                            self.isCreatingPlaylist = true
                            self.errorCreatingPlaylist = false
                            
                            Task {
                                do {
                                    try await homeViewModel.createPlaylistAndAddSongs(
                                        chat: chat,
                                        desiredPlaylistName: playlistName
                                    )
                                    self.isCreatingPlaylist = false
                                    
                                    //set flag that user has tracked a chat, so even if they disconnect they can't create another
                                    UserDefaultsManager.userHasTrackedChat = true
                                    
                                    withAnimation {
                                        self.successfullyCreatedPlaylist = true
                                    }
                                    
                                    await homeViewModel.fetchPlaylist(for: chat)
                                } catch {
                                    self.errorCreatingPlaylist = true
                                    self.isCreatingPlaylist = false
                                }
                            }
                        }
                    )
                    .padding(.leading, 8)
                }
            }
        }
        .frame(width: 450, height: errorCreatingPlaylist ? 275 : 235)
        .padding(.all, 25)
        .disabled(isCreatingPlaylist)
        .onAppear {
            playlistName = chat.displayName
        }
    }
}
