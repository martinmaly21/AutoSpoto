//
//  Chat.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct Chat: Hashable {
    let image: String //base 64 string I believe
    let name: String
    let id: Int

    //this indicates whether a playlist already exists for this chat
    var playlistExists: Bool

    var tracks: [URL] = []

//    let mostRecentSongTime?
//    let mostRecentSong?
//    let numberOfSongs?
}
