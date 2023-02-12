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
        let topInset: CGFloat = 45

        ZStack(alignment: .top) {
            ScrollView {
                Spacer()
                    .frame(height: topInset)
                VStack(spacing: 0) {
                    ForEach(homeViewModel.chats.indices, id: \.self) { index in
                        let chat = homeViewModel.chats[index]
                        ChatRow(chat: chat, isSelected: index == homeViewModel.selectedChatIndex)
                            .onTapGesture {
                                homeViewModel.selectedChatIndex = index
                            }
                    }
                }
            }
            .introspectScrollView { scrollView in
                scrollView.scrollerInsets = NSEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }

            HStack {
                Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                    .font(.josefinSansBold(24))
                    .foregroundColor(.white)
                    .padding(.leading, 18)
                    .padding(.top, 6)
                    .padding(.bottom, 10)

                Spacer()

                Button(
                    action: {
                        //TODO: fetch chats
                    },
                    label: {
                        Image(systemName: "arrow.clockwise")
                    }
                )
                .frame(width: 30, height: 30)
                .padding(.trailing, 18)
            }
            .background(.ultraThinMaterial)
        }
    }
}
