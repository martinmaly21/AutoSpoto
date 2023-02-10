//
//  ChatRow.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatRow: View {
    let chat: Chat
    let isSelected: Bool

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 15) {
                ZStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 60, height: 60)
                .background(Color.gray)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    Text(chat.name)
                        .font(.josefinSansRegular(18))
                        .foregroundColor(.white)

                    Text("18 days ago")
                        .font(.josefinSansLight(18))
                        .foregroundColor(.gray)
                }

                Spacer()

                if chat.playlistExists {
                    Image(systemName: "music.note.list")
                        .resizable()
                        .frame(maxWidth: 20, maxHeight: 20)
                        .foregroundColor(.green)
                }
            }
            .multilineTextAlignment(.leading)

            Divider()
        }
        .padding([.leading, .trailing], 16)
        .frame(maxHeight: 80)
        .contentShape(Rectangle())
        .background(isSelected ? Color.primaryBlue : Color.clear)
    }
}
