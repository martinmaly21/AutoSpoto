//
//  SpotifyPlaylist.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-10.
//

import Foundation

struct SpotifyPlaylist: Codable {
    struct Image: Codable {
        let url: String
    }
    let id: String
    let images: [Image]
    let name: String
    
    var imageURL: URL? {
        guard let imageURLString = images.first?.url else {
            return nil
        }
        return URL(string: imageURLString)
    }
}
