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

                                        ForEach(selectedChat.tracksPages.flatMap({ $0 }), id: \.id) { track in
                                            TrackRow(chat: selectedChat, track: track)
                                                .onAppear {
                                                    //fetch metadata when row appears
                                                    homeViewModel.fetchTracksMetadata(for: selectedChat, spotifyID: track.spotifyID)
                                                }
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

                            CreatePlaylistButton(
                                action: {
                                    showCreatePlaylistSheeet = true
                                }
                            )
                            .padding(.bottom, bottomPadding)
                        }
                    }
                    .environmentObject(homeViewModel)
                }
                VStack {
                    HStack(alignment: .center, spacing: 14) {
                        PersonPictureView(
                            base64ImageString: selectedChat.image,
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
                                selectedChat.tracksPages.flatMap { $0 }.count
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
                isPresented: $showCreatePlaylistSheeet,
                content: {
                    CreatePlaylistView(
                        showCreatePlaylistSheeet: $showCreatePlaylistSheeet,
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
