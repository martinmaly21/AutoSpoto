//
//  SpotifyTracksResponse.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation


struct SpotifyTracksResponse: Codable {
    struct SpotifyTrack: Codable {
        struct Artist: Codable {
            let name: String
        }
        
        struct Album: Codable {
            struct Image: Codable {
                let url: String
            }
            let images: [Image]
        }
        
        let name: String?
        let artists: [Artist]
        let album: Album
        
        var artistName: String? {
            return artists.first?.name
        }
        
        var imageURL: URL? {
            guard let imageURLString = album.images.first?.url else {
                return nil
            }
            
            return URL(string: imageURLString)
        }
    }

    let tracks: [SpotifyTrack?]
}
