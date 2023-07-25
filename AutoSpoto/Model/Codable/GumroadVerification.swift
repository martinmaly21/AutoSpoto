//
//  GumroadVerification.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import Foundation

struct GumroadVerification: Codable {
    struct Purchase: Codable {
        let product_id: String
        let refunded: Bool
        let disputed: Bool
        let dispute_won: Bool
        let chargebacked: Bool
    }
    
    let success: Bool
    let uses: Int
    let purchase: GumroadVerification.Purchase
}
