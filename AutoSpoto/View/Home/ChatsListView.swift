//
//  ChatsListView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatsListView: View {
    let chats: [Chat]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(chats, id: \.self) { chat in
                    Text(chat.name)
                }
            }
        }
    }
}
