//
//  IndividualChatCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct IndividualChatCodable: Codable {
    let Image: String?
    let Phone_Number: String
    let chat_id: [Int]
    let First_Name: String?
    let Last_Name: String?
    let playlist_id: String?
}
    
