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

    static let spotifyAuthEndpoint = URL(string: "https://accounts.spotify.com/api")!
    
    static let spotifyWebAPIEndPoint = URL(string: "https://api.spotify.com/v1")!
    
    static var spotifyLogin: URL {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let state = String((0..<16).compactMap{ _ in letters.randomElement() })
        
        guard let url = URL(string: "https://accounts.spotify.com/en/authorize?client_id=\(clientID)&response_type=code&redirect_uri=\(Self.redirectURI)&scope=playlist-modify-public%20playlist-modify-private%20ugc-image-upload&show_dialog=True&state=\(state)") else {
            fatalError("Could not construct URL")
        }
        
        return url
    }
    
    static let gumroadAPIEndpoint = URL(string: "https://api.gumroad.com/v2/licenses/verify")!
    
    static let autoSpotoProProduct = URL(string: "https://autospoto.gumroad.com/l/pro")!
    static let autoSpotoProProductReceipt = URL(string: "https://app.gumroad.com/d/")!
    static let autoSpotoDisconnectSpotify = URL(string: "https://www.spotify.com/account/apps/")!
    
    static let redirectURI = "spotify-api-example-app://" //this is the redirect URI we set in the Spotify developer dashboard
}
