//
//  JsonToken.swift
//  AutoSpoto
//
//  Created by Andrew Caravaggio on 2023-07-07.
//

import Foundation


struct JsonToken: Codable {
    let access_token: String
    let refresh_token: String
    let expiryDate: Date
    
    var accessTokenHasExpired: Bool {
        return expiryDate < Date()
    }
    
    init(spotifyToken: SpotifyToken) {
        self.access_token = spotifyToken.access_token
        
        guard let refreshToken  = spotifyToken.refresh_token ?? SpotifyTokenManager.readJsonTokenFile()?.refresh_token else {
            //this should never occur, because a user will always have a refresh token if they have retrieved a new acccess token
            //but if it somehow does, we delete existing token so user can start app fresh
            SpotifyTokenManager.deleteJSONTokenFile()
            fatalError("Could not get keychain token")
        }
        self.refresh_token = refreshToken
        
        let calendar = Calendar.current
        guard let expiryDate = calendar.date(byAdding: .second, value: spotifyToken.expires_in, to: Date()) else {
            fatalError("Could not synthesize expiryDate")
        }
        self.expiryDate = expiryDate
    }
}
