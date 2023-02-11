//
//  ChatView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    @Binding var selectedChat: Chat?

    var body: some View {
        let bottomPadding: CGFloat = 25
        let buttonHeight: CGFloat = 40

        if let selectedChat = selectedChat {
            GeometryReader { proxy in
                ZStack(alignment: .bottom) {
                    ScrollView {
                        VStack {
                            Spacer()

                            ForEach(selectedChat.tracks, id: \.self) { url in
                                TrackRow(track: url)
                            }

                            Spacer()
                                .frame(height: bottomPadding + buttonHeight + 16)
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
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
        } else {
            ProgressView()
        }
    }
}
