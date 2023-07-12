//
//  ChatsListView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        let topInset: CGFloat = 80

        ZStack(alignment: .top) {
            ScrollView {
                Spacer()
                    .frame(height: topInset)
                LazyVStack(spacing: 0) {
                    ForEach(homeViewModel.chatSections, id: \.id) { chatSection in
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(chatSection.title) (\(chatSection.chats.count))")
                                    .font(.josefinSansRegular(18))
                                    .padding(.leading, 14)
                                    .padding(.vertical, 4)
                                
                                Spacer()
                            }
                            .background(Color.sectionHeaderGray)
                            
                            if chatSection.chats.isEmpty {
                                Text(AutoSpotoConstants.Strings.CHAT_SECTION_EMPTY_STATE)
                                    .font(.josefinSansLight(16))
                                    .padding(.vertical, 10)
                            } else {
                                ForEach(chatSection.chats, id: \.id) { chat in
                                    ChatRow(
                                        chatImage: chat.image,
                                        chatDisplayName: chat.displayName,
                                        chatSpotifyPlaylistExists: chat.spotifyPlaylistExists,
                                        numberOfTracks: chat.tracks.count,
                                        isSelected: chat == homeViewModel.selectedChat
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
            .introspectScrollView { scrollView in
                scrollView.scrollerInsets = NSEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }

            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                        .font(.josefinSansBold(26))
                        .foregroundColor(.textPrimary)
                    
                    UpgradeToProButton(
                        action: {
                            #warning("TODO: present pro payment screen")
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
                .padding(.top, 10)
                .padding(.bottom, -10)
                
            }
            .frame(height: topInset)
            .background(.ultraThinMaterial)
        }
        .frame(minWidth: 370)
        .frame(maxWidth: .infinity)
    }
}

