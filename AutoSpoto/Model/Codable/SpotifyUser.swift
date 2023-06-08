//
//  SpotifyUser.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

struct SpotifyUser: Codable {
    struct Image: Codable {
        let url: String
    }
    let id: String
    let display_name: String
    let images: [SpotifyUser.Image]
    
    var profileImageURL: URL? {
        guard let imageURLString = images.first?.url else {
            return nil
        }
        return URL(string: imageURLString)
    }
}
