//
//  KeychainToken.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

struct KeychainToken: Codable {
    let access_token: String
    let refresh_token: String
    let expiryDate: Date
    
    var accessTokenHasExpired: Bool {
        return expiryDate < Date()
    }
    
    init(spotifyToken: SpotifyToken) {
        self.access_token = spotifyToken.access_token
        self.refresh_token = spotifyToken.refresh_token
        
        let calendar = Calendar.current
        guard let expiryDate = calendar.date(byAdding: .second, value: spotifyToken.expires_in, to: Date()) else {
            fatalError("Could not synthesize expiryDate")
        }
        self.expiryDate = expiryDate
    }
}
