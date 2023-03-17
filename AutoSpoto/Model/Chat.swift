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
        return tracks.isEmpty && hasAttemptedToFetchTracks
    }

    //this boolean is used to show loading indicator UI
    var hasNotFetchedAndIsFetchingTracks: Bool {
        return !hasAttemptedToFetchTracks && isFetchingTracks
    }

    private var hasAttemptedToFetchTracks = false
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

    mutating func fetchTracksWithNoMetadata() async {
        guard !hasAttemptedToFetchTracks && !isFetchingTracks else { return }

        hasAttemptedToFetchTracks = true
        isFetchingTracks = true

        let trackListWithNoMetadata = await SwiftPythonInterface.getSongs(chat_ids: ids, displayView: false, shouldStripInvalidIDs: false).description

        //if extract script succeeded and chat truly has no tracks, 'None' will be returned
        guard trackListWithNoMetadata != "None" else {
            isFetchingTracks = false
            return
        }

        //TODO: will need to change when apple music is supported
        let trackIDs = trackListWithNoMetadata.groups(for: AutoSpotoConstants.Regex.spotifyTrackIDRegex).compactMap { $0.last }

        tracks = trackIDs.compactMap { Track(trackID: $0) }

        isFetchingTracks = false
    }

    mutating func fetchTracksWithMetadata() async {
        isFetchingTracksMetaData = true

        let trackListWithMetadataString = await SwiftPythonInterface.getSongs(chat_ids: ids, displayView: true).description

        guard trackListWithMetadataString != "{}" else {
            isFetchingTracksMetaData = false
            return
        }

        guard let trackListWithMetadata = trackListWithMetadataString.data(using: .utf8) else {
            fatalError("Could not get jsonData")
        }

        do {
            let decoder = JSONDecoder()
            let tracksCodable = try decoder.decode([LongTrackCodable].self, from: trackListWithMetadata)
            tracks = tracksCodable.compactMap { Track(longTrackCodable: $0) }
        } catch {
            errorFetchingTracks = true
            print(error)
        }

        isFetchingTracksMetaData = false
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.type == rhs.type &&
        lhs.image == rhs.image &&
        lhs.ids == rhs.ids &&
        lhs.playlistID == rhs.playlistID &&
        lhs.tracks == rhs.tracks &&
        lhs.hasAttemptedToFetchTracks == rhs.hasAttemptedToFetchTracks &&
        lhs.isFetchingTracks == rhs.isFetchingTracks &&
        lhs.isFetchingTracksMetaData == rhs.isFetchingTracksMetaData &&
        lhs.errorFetchingTracks == rhs.errorFetchingTracks
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(image)
        hasher.combine(ids)

        hasher.combine(playlistID)

        hasher.combine(tracks)

        hasher.combine(hasAttemptedToFetchTracks)
        hasher.combine(isFetchingTracks)
        hasher.combine(isFetchingTracksMetaData)
        hasher.combine(errorFetchingTracks)
    }
}
