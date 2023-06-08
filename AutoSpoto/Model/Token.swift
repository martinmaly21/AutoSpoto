//
//  Token.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

class Token: Codable {
    let access_token: String
    private let token_type: String
    private let scope: String
    private let expires_in: Int
    private let expires_at: Int
    let refresh_token: String
    var expiryDate: Date!
    
    func updateExpiryDate() {
        let calendar = Calendar.current
        guard let expiryDate = calendar.date(byAdding: .second, value: expires_in, to: Date()) else {
            fatalError("Could not synthesize expiryDate")
        }
        self.expiryDate = expiryDate
    }
    
    var accessTokenHasExpired: Bool {
        return expiryDate > Date()
    }
}
