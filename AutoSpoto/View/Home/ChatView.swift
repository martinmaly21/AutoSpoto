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

    @State private var showCreatePlaylistSheeet = false

    var body: some View {
        let bottomPadding: CGFloat = 25
        let buttonHeight: CGFloat = 40
        let heightOfToolbar: CGFloat = 80

        if let selectedChat = homeViewModel.selectedChat {
            ZStack(alignment: .center) {
                let tracksAreLoading = (!selectedChat.isFetchingTracks && !selectedChat.hasFetchedTracks) || selectedChat.isFetchingTracks

                if tracksAreLoading {
                    ProgressView()
                } else if selectedChat.tracks.isEmpty && selectedChat.hasFetchedTracks {
                    VStack(spacing: 20) {
                        Image(systemName: "headphones")
                            .resizable()
                            .frame(width: 60, height: 60)

                        Text(AutoSpotoConstants.Strings.NO_TRACKS_EMPTY_STATE)
                            .font(.josefinSansRegular(18))
                    }
                } else {
                    GeometryReader { proxy in
                        ZStack(alignment: .bottom) {
                            ScrollViewReader { reader in
                                ScrollView {
                                    LazyVStack {
                                        Spacer()
                                            .frame(height: heightOfToolbar)

                                        Spacer()

                                        ForEach(selectedChat.tracks, id: \.hashValue) { track in
                                            TrackRow(chat: selectedChat, track: track)
                                        }

                                        Spacer()
                                            .frame(height: bottomPadding + buttonHeight + 30)
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
                                    scrollView.scrollerInsets = NSEdgeInsets(top: heightOfToolbar, left: 0, bottom: 0, right: 0)
                                }
                            }

                            Button(
                                action: {
                                    showCreatePlaylistSheeet = true
                                },
                                label: {
                                    //TODO: add shadow on button
                                    Text(AutoSpotoConstants.Strings.CREATE_PLAYLIST)
                                        .font(.josefinSansRegular(18))
                                }
                            )
                            .customButton(foregroundColor: .white, backgroundColor: .primaryBlue)
                            .padding(.bottom, bottomPadding)
                        }
                    }
                    .environmentObject(homeViewModel)
                }
                VStack {
                    HStack(alignment: .center, spacing: 14) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .background(Color.gray)
                            .clipShape(Circle())

                        Text(selectedChat.displayName)
                            .font(.josefinSansRegular(20))
                            .foregroundColor(.white)

                        Spacer()

                        Text(
                            String.localizedStringWithFormat(
                                AutoSpotoConstants.Strings.NUMBER_OF_TRACKS,
                                selectedChat.tracks.count
                            )
                        )
                        .font(.josefinSansRegular(18))
                        .foregroundColor(.white)
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
                isPresented: $showCreatePlaylistSheeet,
                content: {
                    CreatePlaylistView(
                        showCreatePlaylistSheeet: $showCreatePlaylistSheeet,
                        chat: selectedChat
                    )
                }
            )
        } else {
            ProgressView()
        }
    }
}
