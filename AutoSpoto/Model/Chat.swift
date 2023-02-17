//
//  Chat.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct Chat: Hashable {
    let type: ChatType
    let image: String? //base 64 string I believe
    let id: Int

    //this indicates whether a playlist already exists for this chat
    var playlistExists: Bool

    var tracks: [Track] = []

    var hasFetchedTracks = false
    var isFetchingTracks = false
    var errorFetchingTracks = false

    var displayName: String {
        switch type {
        case .individual(let firstName, let lastName):
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            } else if let firstName = firstName {
                return firstName
            } else if let lastName = lastName {
                return lastName
            } else {
                fatalError("Individual chat has no name")
            }
        case .group(let name):
            if let name = name {
                return name
            } else {
                fatalError("Group chat has no name")
            }
        }
    }

    init(_ individualChatCodable: IndividualChatCodable) {
        type = .individual(
            firstName: individualChatCodable.First_Name,
            lastName: individualChatCodable.Last_Name
        )
        image = individualChatCodable.Image_Blob
        id = individualChatCodable.chat_id
        playlistExists = individualChatCodable.playlist_id
    }

    init(_ groupChatCodable: GroupChatCodable) {
        type = .group(name: groupChatCodable.display_name)
        image = nil //TODO
        //        image = individualChatCodable.Image_Blob
        id = groupChatCodable.chat_id
        playlistExists = groupChatCodable.playlist_id
    }

    mutating func fetchTracks() async {
        guard !hasFetchedTracks && !isFetchingTracks else { return }

        hasFetchedTracks = true
        isFetchingTracks = true

        let jsonString = await SwiftPythonInterface.extractScript(chat_id: id, displayView: true).description
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Could not get jsonData")
        }

        do {
            let decoder = JSONDecoder()
            let tracksCodable = try decoder.decode([TrackCodable].self, from: jsonData)
            tracks = tracksCodable.compactMap { Track(trackCodable: $0) }
        }
        catch {
            //TODO: handle error better
            isFetchingTracks = false
            errorFetchingTracks = true
            print (error)
        }

        isFetchingTracks = false
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.type == rhs.type &&
        lhs.image == rhs.image &&
        lhs.id == rhs.id &&
        lhs.playlistExists == rhs.playlistExists &&
        lhs.tracks == rhs.tracks &&
        lhs.hasFetchedTracks == rhs.hasFetchedTracks &&
        lhs.isFetchingTracks == rhs.isFetchingTracks &&
        lhs.errorFetchingTracks == rhs.errorFetchingTracks
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(image)
        hasher.combine(id)

        hasher.combine(playlistExists)

        hasher.combine(tracks)

        hasher.combine(hasFetchedTracks)
        hasher.combine(isFetchingTracks)
        hasher.combine(errorFetchingTracks)
    }
}
