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

    var tracksPages: [[Track]] = []
    
    //we will fetch metadata for 30 tracks at a time
    let numberOfTrackMetadataPerFetch = 30

    var hasNoTracks: Bool {
        return tracksPages.isEmpty && hasFetchedTracksIDs
    }

    //this boolean is used to show loading indicator UI
    var hasNotFetchedAndIsFetchingTracks: Bool {
        return !hasFetchedTracksIDs && isFetchingTrackIDs
    }

    private var hasFetchedTracksIDs = false
    private var isFetchingTrackIDs = false
    
    private var trackMetadataPagesBeingFetched: [Int] = []
    private var trackMetadataPagesFetched: [Int] = []

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
            firstName: individualChatCodable.firstName,
            lastName: individualChatCodable.lastName,
            phoneNumber: individualChatCodable.contactInfo
        )
        image = individualChatCodable.imageBlob
        ids = individualChatCodable.chatIDs
        playlistID = individualChatCodable.spotifyPlaylistID //TODO: cahnge
    }

    init(_ groupChatCodable: GroupChatCodable) {
        type = .group(name: groupChatCodable.display_name)
        image = groupChatCodable.Image
        ids = groupChatCodable.chat_ids
        playlistID = groupChatCodable.playlist_id
    }
    
    mutating func fetchTrackIDs() async {
        //MARK: - first fetch track IDs to show row count
        guard !hasFetchedTracksIDs && !isFetchingTrackIDs else { return }
        
        isFetchingTrackIDs = true
        
        let tracksWithNoMetadata = await DatabaseManager.shared.fetchSpotifyTracksWithNoMetadata(for: ids)
        
        var tracksPage: [Track] = []
        
        //split track IDs in chunks of 'numberOfTrackMetadataPerFetch'
        for track in tracksWithNoMetadata {
            tracksPage.append(track)
            if tracksPage.count == numberOfTrackMetadataPerFetch {
                tracksPages.append(tracksPage)
                tracksPage.removeAll()
            }
        }
        if !tracksPage.isEmpty {
            tracksPages.append(tracksPage)
        }
        
        hasFetchedTracksIDs = true
        isFetchingTrackIDs = false
    }

    mutating func fetchTracksMetadata(spotifyID: String) async {
        let page = getPage(for: spotifyID)
        
        guard !trackMetadataPagesBeingFetched.contains(page) && !trackMetadataPagesFetched.contains(page) else {
            return
        }
        
        trackMetadataPagesBeingFetched.append(page)
        
        let tracksMetadataToFetch = getTracks(for: page)
        let fetchedTracksMetadata = (try? await SpotifyManager.fetchTrackMetadata(for: tracksMetadataToFetch)) ?? []
        
        for (index, track) in fetchedTracksMetadata.enumerated() {
            tracksPages[page][index] = track
        }
        
        trackMetadataPagesFetched.append(page)
        trackMetadataPagesBeingFetched.removeAll(where: { $0 == page })
    }
    
    private func getPage(for spotifyID: String) -> Int {
        for (page, tracksPage) in tracksPages.enumerated() {
            let trackExistsInPage = tracksPage.firstIndex(where: { $0.spotifyID == spotifyID }) != nil
            
            if trackExistsInPage {
                return page
            }
        }
        
        fatalError("Could not get track page")
    }
    
    private func getTracks(for page: Int) -> [Track] {
        return tracksPages[page]
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.ids == rhs.ids
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(image)
        hasher.combine(ids)

        hasher.combine(playlistID)

        hasher.combine(tracksPages)

        hasher.combine(hasFetchedTracksIDs)
        hasher.combine(isFetchingTrackIDs)
        
        hasher.combine(trackMetadataPagesBeingFetched)
        hasher.combine(trackMetadataPagesFetched)
    }
}
