//
//  GroupChatCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct GroupChatCodable: Codable {
    let chat_ids: [Int]
    let display_name: String
    let Image: Data?
    let playlist_id: String?
    let last_updated: String?
}
