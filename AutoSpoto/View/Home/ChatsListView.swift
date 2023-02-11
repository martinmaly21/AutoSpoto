//
//  ChatsListView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatsListView: View {
    let chats: [Chat]
    @Binding var selectedChat: Chat?

    var body: some View {
        let topInset: CGFloat = 45

        ZStack(alignment: .top) {
            ScrollView {
                Spacer()
                    .frame(height: topInset)
                VStack {
                    ForEach(chats, id: \.self) { chat in
                        ChatRow(chat: chat, isSelected: chat == selectedChat)
                            .onTapGesture {
                                selectedChat = chat
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
            }
            .background(.ultraThinMaterial)
        }
    }
}
