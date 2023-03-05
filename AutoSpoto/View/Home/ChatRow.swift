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
        VStack(spacing: 2) {
            HStack(alignment: .center, spacing: 15) {
                PersonPictureView(
                    base64ImageString: chat.image,
                    dimension: 40,
                    isSelected: isSelected
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text(chat.displayName)
                        .font(.josefinSansRegular(18))
                        .foregroundColor(isSelected ? .textPrimaryWhite : .textPrimary)
                }

                Spacer()

                if chat.playlistExists {
                    Image(systemName: "music.note.list")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.spotifyGreen)
                }
            }
            .multilineTextAlignment(.leading)
            .padding([.leading, .trailing], 16)
            .padding(.bottom, 8)

            Rectangle()
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .opacity(isSelected ? 0 : 1)
        }
        .padding(.top, 8)
        .frame(maxHeight: 60)
        .contentShape(Rectangle())
        .background(isSelected ? Color.primaryBlue : Color.clear)
        .cornerRadius(6)
    }
}
