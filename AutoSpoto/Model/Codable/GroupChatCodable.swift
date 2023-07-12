//
//  GroupChatCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct GroupChatCodable: Codable {
    let ids: [Int] //this is an array because each chat can have a text message or imessage thread associated with it
    
    let imageBlob: Data?
    let nameID: String // a group chat may not have a name, but it will always have an ID
    let name: String?
    
    let spotifyPlaylistID: String?
    let lastUpdated: Double?
}
