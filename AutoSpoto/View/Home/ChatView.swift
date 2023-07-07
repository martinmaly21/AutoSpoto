//
//  ChatView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Namespace var bottomID
    
    @State private var showCreatePlaylistSheet = false
    
    var body: some View {
        let createButtonHeight: CGFloat = 60
        let playlistSummaryHeight: CGFloat = 150
        let heightOfToolbar: CGFloat = 80
        
        if homeViewModel.isFetchingChats {
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
                                                TrackRow(track: track)
                                                    .id(track.id)
                                                    .onAppear {
                                                        reader.scrollTo(selectedChat.tracks.last?.id)
                                                        
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
                                chat: selectedChat,
                                width: proxy.size.width,
                                height: playlistSummaryHeight
                            )
                            .onAppear {
                                Task {
                                    await homeViewModel.fetchPlaylist(for: selectedChat)
                                }
                            }
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
                                isSelected: false
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
                let emptyStateTitle = homeViewModel.filterSelection == .individual ? AutoSpotoConstants.Strings.NO_INDIVIDUAL_CHATS_EMPTY_STATE : AutoSpotoConstants.Strings.NO_GROUP_CHATS_EMPTY_STATE
                
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
