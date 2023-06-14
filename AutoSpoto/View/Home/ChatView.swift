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
        
        if let selectedChat = homeViewModel.selectedChat {
            ZStack(alignment: .center) {
                let tracksAreLoading = selectedChat.hasNotFetchedAndIsFetchingTracks
                
                if tracksAreLoading {
                    ProgressView()
                } else if selectedChat.hasNoTracks {
                    VStack(spacing: 20) {
                        Image(systemName: "headphones")
                            .resizable()
                            .frame(width: 60, height: 60)
                        
                        Text(AutoSpotoConstants.Strings.NO_TRACKS_EMPTY_STATE)
                            .font(.josefinSansRegular(18))
                    }
                    .foregroundColor(.emptyStateTintColor)
                } else {
                    GeometryReader { proxy in
                        ZStack(alignment: .bottom) {
                            ScrollViewReader { reader in
                                ScrollView {
                                    LazyVStack {
                                        Spacer()
                                            .frame(height: heightOfToolbar)
                                        
                                        Spacer()
                                        
                                        ForEach(selectedChat.tracks, id: \.id) { track in
                                            TrackRow(track: track)
                                                .onAppear {
                                                    //fetch metadata when row appears
                                                    Task {
                                                        await homeViewModel.fetchTracksMetadata(for: selectedChat, spotifyID: track.spotifyID)
                                                    }
                                                }
                                        }
                                        
                                        Spacer()
                                            .frame(height: (selectedChat.spotifyPlaylistExists ? playlistSummaryHeight : createButtonHeight) + 15)
                                            .id(bottomID)
                                    }
                                    .frame(minHeight: proxy.size.height)
                                }
                                .onReceive(homeViewModel.$scrollToBottom, perform: { publish in
                                    
                                    //may need to change this when track fetching is async
                                    //since the number of chats won't be determined until the query is finished
                                    reader.scrollTo(bottomID)
                                })
                                .frame(width: proxy.size.width)
                                .introspectScrollView { scrollView in
                                    scrollView.scrollerInsets = NSEdgeInsets(top: heightOfToolbar, left: 0, bottom: selectedChat.spotifyPlaylistExists ? playlistSummaryHeight : createButtonHeight, right: 0)
                                }
                            }
                            
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
                    }
                    .environmentObject(homeViewModel)
                }
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
                        .redacted(reason: tracksAreLoading ? .placeholder : [])
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
            ProgressView()
        }
    }
}
