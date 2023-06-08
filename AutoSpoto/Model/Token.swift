//
//  Token.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

struct Token: Codable {
    let access_token: String
    private let token_type: String
    private let scope: String
    private let expires_in: Int
    let refresh_token: String
    
    private var expiryDate: Date? {
        let calendar = Calendar.current
        guard let expiryDate = calendar.date(byAdding: .second, value: expires_in, to: Date()) else {
            return nil
        }
        return expiryDate
    }
    
    var accessTokenHasExpired: Bool {
        guard let expiryDate = expiryDate else {
            return true
        }
        return expiryDate > Date()
    }
}
