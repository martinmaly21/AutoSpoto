//
//  Chat.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

class Chat: Equatable, Identifiable {
    let type: ChatType
    let image: Data?
    let ids: [Int] //this is an array because each chat can have a text message or imessage thread associated with it
    let lastUpdated: Date?
    //this indicates whether a playlist already exists for this chat
    var spotifyPlaylistID: String?

    var spotifyPlaylistExists: Bool {
        return spotifyPlaylistID != nil
    }
    
    //fetched from Spotify
    var spotifyPlaylist: SpotifyPlaylist?

    var tracksPages: [[Track]] = []
    
    var tracks: [Track] {
        return tracksPages.flatMap({ $0 })
    }
    
    //we will fetch metadata for 15 tracks at a time
    let numberOfTrackMetadataPerFetch = 15
    
    var optedInToAutomaticChatUpdates = true

    var hasTracks: Bool {
        return !tracks.isEmpty
    }
    
    var trackMetadataPagesBeingFetched: [Int] = []
    var trackMetadataPagesFetched: [Int] = []
    
    var isGroupChat: Bool {
        switch type {
        case .group(_):
            return true
        default:
            return false
        }
    }

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
        spotifyPlaylistID = individualChatCodable.spotifyPlaylistID
        if let lastUpdated = individualChatCodable.lastUpdated {
            self.lastUpdated = Date(timeIntervalSince1970: lastUpdated)
        } else {
            self.lastUpdated = nil
        }
    }

    init(_ groupChatCodable: GroupChatCodable) {
        type = .group(name: groupChatCodable.display_name)
        image = groupChatCodable.Image
        ids = groupChatCodable.chat_ids
        spotifyPlaylistID = groupChatCodable.playlist_id
        if let lastUpdated = groupChatCodable.lastUpdated {
            self.lastUpdated = Date(timeIntervalSince1970: lastUpdated)
        } else {
            self.lastUpdated = nil
        }
    }
    
    func getPage(for spotifyID: String? = nil) -> Int? {
        guard hasTracks else {
            return nil
        }
        
        //for the initial fetch we pass in a nil spotifyID, so just pass in the first page
        guard let spotifyID else {
            return 0
        }
        
        for (page, tracksPage) in tracksPages.enumerated() {
            let trackExistsInPage = tracksPage.firstIndex(where: { $0.spotifyID == spotifyID }) != nil
            
            if trackExistsInPage {
                return page
            }
        }
        
        fatalError("Could not get track page")
    }
    
    func getTracks(for page: Int) -> [Track] {
        return tracksPages[page]
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.ids == rhs.ids
    }
}
