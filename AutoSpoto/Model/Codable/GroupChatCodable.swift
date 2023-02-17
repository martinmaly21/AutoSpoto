//
//  GroupChatCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct GroupChatCodable: Codable {
    let chat_id: Int
    let display_name: String
    let Image: String?
    let playlist_id: String?
}
