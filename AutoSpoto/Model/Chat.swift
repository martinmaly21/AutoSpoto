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
    let ids: [Int]

    //this indicates whether a playlist already exists for this chat
    var playlistID: String?

    var playlistExists: Bool {
        return playlistID != nil
    }

    var tracks: [Track] = []

    var hasNoTracks: Bool {
        return tracks.isEmpty && hasFetchedTracks
    }

    //this boolean is used to show loading indicator UI
    var hasNotFetchedAndIsFetchingTracks: Bool {
        return !hasFetchedTracks && isFetchingTracks
    }

    private var hasFetchedTracks = false
    private var isFetchingTracks = false
    var isFetchingTracksMetaData = false
    var errorFetchingTracks = false

    var displayName: String {
        switch type {
        case .individual(let firstName, let lastName, let phoneNumber):
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            } else if let firstName = firstName {
                return firstName
            } else if let lastName = lastName {
                return lastName
            } else {
                return phoneNumber
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
            lastName: individualChatCodable.Last_Name,
            phoneNumber: individualChatCodable.Phone_Number
        )
        image = individualChatCodable.Image
        ids = individualChatCodable.chat_ids
        playlistID = individualChatCodable.playlist_id //TODO: cahnge
    }

    init(_ groupChatCodable: GroupChatCodable) {
        type = .group(name: groupChatCodable.display_name)
        image = groupChatCodable.Image
        ids = groupChatCodable.chat_ids
        playlistID = groupChatCodable.playlist_id
    }

    mutating func fetchTracks() async {
        guard !hasFetchedTracks && !isFetchingTracks else { return }

        hasFetchedTracks = true
        isFetchingTracks = true

        let jsonString = await SwiftPythonInterface.extractScript(chat_ids: ids, displayView: true).description
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
        lhs.ids == rhs.ids &&
        lhs.playlistID == rhs.playlistID &&
        lhs.tracks == rhs.tracks &&
        lhs.hasFetchedTracks == rhs.hasFetchedTracks &&
        lhs.isFetchingTracks == rhs.isFetchingTracks &&
        lhs.errorFetchingTracks == rhs.errorFetchingTracks
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(image)
        hasher.combine(ids)

        hasher.combine(playlistID)

        hasher.combine(tracks)

        hasher.combine(hasFetchedTracks)
        hasher.combine(isFetchingTracks)
        hasher.combine(errorFetchingTracks)
    }
}
