//
//  IndividualChatCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct IndividualChatCodable: Codable {
    let imageBlob: String?
    let contactInfo: String
    let chatIDs: [Int]
    let firstName: String?
    let lastName: String?
    let spotifyPlaylistID: String?
}
    
