//
//  AutoSpotoConstants+HTTPParameter.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

extension AutoSpotoConstants {
    struct HTTPParameter {
        private init() {}
    }
}

extension AutoSpotoConstants.HTTPParameter {
    //spotify
    static let grant_type = "grant_type"
    static let redirect_uri = "redirect_uri"
    static let code = "code"
    static let refresh_token = "refresh_token"
    static let ids = "ids"
    static let name = "name"
    static let description = "description"
    static let uris = "uris"
    static let fields = "fields"
    static let id = "id"
    static let images = "images"
    static let playlistCoverImage = "playlistCoverImage"
    
    //gumroad
    static let product_id = "product_id"
    static let license_key = "license_key"
    static let increment_uses_count = "increment_uses_count"
}
