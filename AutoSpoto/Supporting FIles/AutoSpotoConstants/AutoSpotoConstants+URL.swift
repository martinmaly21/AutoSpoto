//
//  AutoSpotoConstants+URL.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import Foundation

extension AutoSpotoConstants {
    struct URL {
        private init() {}
    }
}

extension AutoSpotoConstants.URL {
    static let fullDiskAccess = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!

    static let spotifyEndpoint = URL(string: "https://accounts.spotify.com/api")!
    
    static var spotifyLogin: URL {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let state = String((0..<16).compactMap{ _ in letters.randomElement() })
        
        guard let url = URL(string: "https://accounts.spotify.com/en/authorize?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)&scope=playlist-modify-public&state=\(state)") else {
            fatalError("Could not construct URL")
        }
        
        return url
    }
}
