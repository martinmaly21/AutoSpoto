//
//  ChatsListView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    @State private var isPresentingUpgradeToPro = false

    var body: some View {
        let topInset: CGFloat = 90

        ZStack(alignment: .top) {
            ScrollView {
                Spacer()
                    .frame(height: topInset)
                LazyVStack(spacing: 0) {
                    ForEach(homeViewModel.filteredChatSections, id: \.id) { chatSection in
                        let chatSectionIsExpanded = (
                            chatSection.title == AutoSpotoConstants.Strings.SPOTIFY_PLAYLIST_EXISTS_SECTION && homeViewModel.connectedChatsIsExpanded ||
                            chatSection.title == AutoSpotoConstants.Strings.CHATS_WITH_TRACKS && homeViewModel.chatsWithTracksIsExpanded ||
                            chatSection.title == AutoSpotoConstants.Strings.CHATS_WITH_NO_TRACKS && homeViewModel.chatsWithNoTracksIsExpanded
                        )
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(width: 25)
                                    .rotationEffect(chatSectionIsExpanded ? .radians(.pi / 2) : .radians(0))
                                    .padding(.leading, 12)
                                    
                                Text("\(chatSection.title) (\(chatSection.chats.count))")
                                    .font(.josefinSansRegular(18))
                                    .padding(.vertical, 4)
                                
                                Spacer()
                            }
                            .background(Color.sectionHeaderGray)
                            .onTapGesture {
                                withAnimation {
                                    switch chatSection.title {
                                    case AutoSpotoConstants.Strings.SPOTIFY_PLAYLIST_EXISTS_SECTION:
                                        homeViewModel.connectedChatsIsExpanded.toggle()
                                    case AutoSpotoConstants.Strings.CHATS_WITH_TRACKS:
                                        homeViewModel.chatsWithTracksIsExpanded.toggle()
                                    case AutoSpotoConstants.Strings.CHATS_WITH_NO_TRACKS:
                                        homeViewModel.chatsWithNoTracksIsExpanded.toggle()
                                    default:
                                        fatalError("Unexpected section title")
                                    }
                                }
                            }
                            
                            if chatSection.chats.isEmpty {
                                Text(AutoSpotoConstants.Strings.CHAT_SECTION_EMPTY_STATE)
                                    .font(.josefinSansRegular(16))
                                    .padding(.vertical, 10)
                            } else {
                                
                                if chatSectionIsExpanded {
                                    ForEach(chatSection.chats, id: \.id) { chat in
                                        ChatRow(
                                            chatImage: chat.image,
                                            chatDisplayName: chat.displayName,
                                            chatSpotifyPlaylistExists: chat.spotifyPlaylistExists,
                                            numberOfTracks: chat.tracks.count,
                                            numberOfUnsyncedTracks: chat.numberOfUnsyncedTracks,
                                            isSelected: chat == homeViewModel.selectedChat,
                                            isGroupChat: chat.isGroupChat
                                        )
                                        .onTapGesture {
                                            homeViewModel.selectedChat = chat
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .introspectScrollView { scrollView in
                scrollView.scrollerInsets = NSEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }

            VStack(spacing: 20) {
                HStack(alignment: .center) {
                    Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                        .font(.josefinSansBold(26))
                        .foregroundColor(.textPrimary)
                    
                    UpgradeToProButton(
                        action: {
                            isPresentingUpgradeToPro = true
                        }
                    )

                    Spacer()

                    Button(
                        action: {
                            Task {
                               await homeViewModel.resetModel()
                            }
                        },
                        label: {
                            ZStack {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .bold()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.refreshButtonTextColor)
                            }
                            .padding(.leading, 24)
                            .frame(width: 50, height: 40)
                            .clipShape(Capsule())
                            .aspectRatio(contentMode: .fit)
                        }
                    )
                    .buttonStyle(.plain)

                }
                .padding(.horizontal, 16)
                .padding(.bottom, -10)
                
                ChatTypeFilter()
                    .padding(.bottom, 5)
            }
            .frame(height: topInset)
            .background(.ultraThinMaterial)
        }
        .frame(minWidth: 370)
        .frame(maxWidth: .infinity)
        .sheet(
            isPresented: $isPresentingUpgradeToPro,
            content: {
                AutoSpotoProUpgradeView(showCreatePlaylistSheet: $isPresentingUpgradeToPro)
            }
        )
    }
}

