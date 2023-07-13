//
//  ChatView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    @State private var showCreatePlaylistSheet = false
    
    var body: some View {
        let createButtonHeight: CGFloat = 60
        let playlistSummaryHeight: CGFloat = 110
        let heightOfToolbar: CGFloat = 80
        
        if homeViewModel.isFetchingChats && homeViewModel.chatSections.isEmpty {
            ProgressView()
        } else {
            if let selectedChat = homeViewModel.selectedChat {
                //there exists at least one chat
                GeometryReader { proxy in
                    ZStack(alignment: .center) {
                        ZStack(alignment: .bottom) {
                            ScrollViewReader { reader in
                                ScrollView {
                                    if selectedChat.hasTracks {
                                        LazyVStack {
                                            ForEach(selectedChat.tracks, id: \.id) { track in
                                                TrackRow(chat: selectedChat, track: track)
                                                    .id(track.id)
                                                    .onAppear {
                                                        if homeViewModel.shouldScrollToBottom {
                                                            homeViewModel.shouldScrollToBottom = false
                                                            
                                                            reader.scrollTo(selectedChat.tracks.last?.id)
                                                            
                                                            //after scrolling chat to bottom, fetch the playlist if it exists
                                                            if selectedChat.spotifyPlaylistExists {
                                                                Task {
                                                                    await homeViewModel.fetchPlaylist(for: selectedChat)
                                                                }
                                                            }
                                                        }
                                                        
                                                        //fetch metadata when row appears
                                                        Task {
                                                            await homeViewModel.fetchTracksMetadata(for: selectedChat, spotifyID: track.spotifyID)
                                                        }
                                                    }
                                            }
                                        }
                                        .frame(minHeight: proxy.size.height - heightOfToolbar - (selectedChat.spotifyPlaylistExists ? playlistSummaryHeight : createButtonHeight) - 8, alignment: .bottom)
                                    } else {
                                        VStack(spacing: 20) {
                                            Image(systemName: "headphones")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                            
                                            Text(AutoSpotoConstants.Strings.NO_TRACKS_EMPTY_STATE)
                                                .font(.josefinSansRegular(18))
                                        }
                                        .frame(height: proxy.size.height - heightOfToolbar - (selectedChat.spotifyPlaylistExists ? playlistSummaryHeight : createButtonHeight) - 8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.emptyStateTintColor)
                                        .onAppear {
                                            if selectedChat.spotifyPlaylistExists {
                                                Task {
                                                    await homeViewModel.fetchPlaylist(for: selectedChat)
                                                }
                                            }
                                        }
                                    }
                                }
                                .safeAreaInset(edge: .top) {
                                    Spacer()
                                        .frame(height: heightOfToolbar)
                                }
                            }
                        }
                    }
                    .environmentObject(homeViewModel)
                    .safeAreaInset(edge: .bottom) {
                        if selectedChat.spotifyPlaylistExists {
                            PlaylistSummaryView(
                                width: proxy.size.width,
                                height: playlistSummaryHeight
                            )
                        } else {
                            CreatePlaylistButton(
                                width: proxy.size.width,
                                height: createButtonHeight,
                                action: {
                                    showCreatePlaylistSheet = true
                                }
                            )
                        }
                    }
                    .frame(width: proxy.size.width)
                    VStack {
                        HStack(alignment: .center, spacing: 14) {
                            PersonPictureView(
                                base64ImageData: selectedChat.image,
                                dimension: 45,
                                isSelected: false,
                                isGroupChat: selectedChat.isGroupChat
                            )
                            
                            Text(selectedChat.displayName)
                                .font(.josefinSansRegular(20))
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Text(
                                String.localizedStringWithFormat(
                                    AutoSpotoConstants.Strings.NUMBER_OF_TRACKS,
                                    selectedChat.tracks.count
                                )
                            )
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.textPrimary)
                        }
                        .padding(.horizontal, 16.5)
                        .frame(height: heightOfToolbar)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        
                        Spacer()
                    }
                }
                .sheet(
                    isPresented: $showCreatePlaylistSheet,
                    content: {
                        CreatePlaylistView(
                            showCreatePlaylistSheet: $showCreatePlaylistSheet,
                            chat: selectedChat
                        )
                        .environmentObject(homeViewModel)
                    }
                )
            } else {
                //no chats
                let emptyStateTitle = AutoSpotoConstants.Strings.NO_CHATS_EMPTY_STATE
                
                VStack(spacing: 10) {
                    Image(systemName: "message")
                        .resizable()
                        .tint(Color.white)
                        .frame(width: 50, height: 50)
                    
                    Text(emptyStateTitle)
                        .font(.josefinSansRegular(18))
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}
