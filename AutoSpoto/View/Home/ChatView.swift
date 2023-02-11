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

    @Binding var selectedChat: Chat?

    var body: some View {
        let bottomPadding: CGFloat = 25
        let buttonHeight: CGFloat = 40
        let heightOfToolbar: CGFloat = 80

        if let selectedChat = selectedChat {
            ZStack(alignment: .top) {
                if selectedChat.tracks.isEmpty && selectedChat.tracksHaveBeenFetched {
                    VStack(spacing: 20){
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
                                ScrollView(showsIndicators: false) {
                                    VStack {
                                        Spacer()
                                            .frame(height: heightOfToolbar)

                                        Spacer()

                                        ForEach(selectedChat.tracks, id: \.self) { url in
                                            TrackRow(track: url)
                                        }

                                        Spacer()
                                            .frame(height: bottomPadding + buttonHeight + 30)
                                            .id(bottomID)
                                    }
                                    .frame(minHeight: proxy.size.height)
                                }
                                .introspectScrollView { scrollView in
                                    scrollView.scrollerInsets = NSEdgeInsets(top: heightOfToolbar, left: 0, bottom: 0, right: 0)
                                }

                                .frame(width: proxy.size.width)
                                .onChange(
                                    of: selectedChat,
                                    perform: { _ in
                                        //may need to change this when track fetching is async
                                        //since the number of chats won't be determined until the query is finished
                                        reader.scrollTo(bottomID)
                                    }
                                )
                            }

                            Button(
                                action: {
                                    //TODO: User pressed 'Create playlist'
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
                }

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
                            AutoSpotoConstants.Strings.NUMBER_OF_SONGS,
                            selectedChat.tracks.count
                        )
                    )
                    .font(.josefinSansRegular(18))
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 16.5)
                .frame(height: heightOfToolbar)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
        } else {
            ProgressView()
        }
    }
}
