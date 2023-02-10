//
//  ChatRow.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatRow: View {
    let chat: Chat

    var body: some View {
        VStack {
            HStack {
                ZStack {

                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                }

                .frame(width: 60, height: 60)
                .background(Color.gray)
                .clipShape(Circle())

                VStack(spacing: 12) {
                    Text(chat.name)
                        .font(.josefinSansBold(18))
                        .foregroundColor(.white)

                    Text("18 days ago")
                        .font(.josefinSansLight(18))
                        .foregroundColor(.white)
                }

                if chat.playlistExists {
                    //add indicator that chat is currently tracked
                }

                Spacer()
            }
            .multilineTextAlignment(.leading)

            Divider()
        }
        .padding()
    }
}
