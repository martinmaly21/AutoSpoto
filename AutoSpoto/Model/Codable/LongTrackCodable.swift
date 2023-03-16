//
//  TrackCodable.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import Foundation

struct LongTrackCodable: Codable {
    let track_id: String
    let date_utc: String?

    //metadata
    let image_ref: String?
    let song_name: String?
    let artist_name: String?
    let album_name: String?
    let release_year: String?
    let preview_url: String?
}
