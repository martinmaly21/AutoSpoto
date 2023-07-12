//
//  GroupChatCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct GroupChatCodable: Codable {
    let chat_ids: [Int] //this is an array because each chat can have a text message or imessage thread associated with it
    let display_name: String
    let Image: Data?
    let playlist_id: String?
    let lastUpdated: Double?
}
