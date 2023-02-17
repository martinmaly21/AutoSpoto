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
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 15) {
                ZStack {
                    if let base64ImageString = chat.image,
                       let base64ImageStringData = Data(base64Encoded: base64ImageString),
                       let nsImage = NSImage(data: base64ImageStringData) {
                        Image(nsImage: nsImage)
                            .resizable()
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                    }
                }

                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .background(Color.gray)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    Text(chat.displayName)
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
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                }
            }
            .multilineTextAlignment(.leading)
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 15)
        }
        .frame(maxHeight: 80)
        .contentShape(Rectangle())
        .background(isSelected ? Color.primaryBlue : Color.clear)
        .cornerRadius(6)
    }
}
