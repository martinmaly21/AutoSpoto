//
//  SpotifyToken.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

struct SpotifyToken: Codable {
    let access_token: String
    private let token_type: String
    private let scope: String
    let expires_in: Int
    var refresh_token: String?
}
