//
//  ChatSection.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-05.
//

import Foundation

struct ChatSection: Identifiable {
    var id: String { title }
    
    var title: String
    var chats: [Chat]
}
