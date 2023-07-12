//
//  GroupChatCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct GroupChatCodable: Codable {
    let chatIDs: [Int] //this is an array because each chat can have a text message or imessage thread associated with it
    
    let imageBlob: Data?
    let displayName: String
    
    let spotifyPlaylistID: String?
    let lastUpdated: Double?
}
