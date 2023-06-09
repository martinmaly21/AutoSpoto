//
//  HomeViewModel.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var individualChats: [Chat] = []
    @Published var groupChats: [Chat] = []

    @Published var selectedIndividualChat: Chat?
    @Published var selectedGroupChat: Chat?

    @Published var filterSelection: FilterChatType = .individual

    @Published var scrollToBottom = false

    var selectedChat: Chat? {
        get {
            switch filterSelection {
            case .individual:
                return selectedIndividualChat
            case .group:
                return selectedGroupChat
            }
        }

        set {
            switch filterSelection {
            case .individual:
                selectedIndividualChat = newValue
            case .group:
                selectedGroupChat = newValue
            }

            scrollToBottom = true
        }
    }

    var chats: [Chat] {
        switch filterSelection {
        case .individual:
            return individualChats
        case .group:
            return groupChats
        }
    }
    
    init() {
        #warning("Will need to update")
        let databaseString = "/Users/martinmaly/Developer/AutoSpoto/AutoSpoto/Backend/autospoto.db"
        let addressBookID = "0E0A58CC-863C-47F3-9C70-A81612E240C4"
        DatabaseManager.shared = DatabaseManager(databaseString: databaseString, addressBookID: addressBookID)
    }

    public func fetchChats() async {
        switch filterSelection {
        case .individual:
            await fetchIndividualChats()
        case .group:
            await fetchGroupChats()
        }
    }

    private func fetchGroupChats() async {
        //only fetch if group chats have not already been fetched (groupChats.isEmpty)
        guard groupChats.isEmpty else { return }

        let groupChatsJSON = DatabaseManager.shared.fetchGroupChats()

        do {
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([GroupChatCodable].self, from: groupChatsJSON)
            groupChats = tableData.map { Chat($0) }
        } catch let error {
            fatalError("Could not decode chats: \(error)")
        }
        

        selectedGroupChat = groupChats.first
    }

    private func fetchIndividualChats() async {
        //only fetch if individual chats have not already been fetched (individualChats.isEmpty)
        guard individualChats.isEmpty else { return }
        
        let indivualChatsJSON = DatabaseManager.shared.fetchIndividualChats()
        
        do {
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([IndividualChatCodable].self, from: indivualChatsJSON)
            individualChats = tableData.map { Chat($0) }
        } catch let error {
            fatalError("Could not decode chats: \(error)")
        }
        
        selectedIndividualChat = individualChats.first
    }
    
    func fetchTrackIDs(for chat: Chat) async {
        //MARK: - first fetch track IDs to show row count
        guard !chat.hasFetchedTracksIDs && !chat.isFetchingTrackIDs else { return }
        
        chat.isFetchingTrackIDs = true
        
        let tracksWithNoMetadata = await DatabaseManager.shared.fetchSpotifyTracksWithNoMetadata(for: chat.ids)
        
        var tracksPage: [Track] = []
        
        //split track IDs in chunks of 'numberOfTrackMetadataPerFetch'
        for track in tracksWithNoMetadata {
            tracksPage.append(track)
            if tracksPage.count == chat.numberOfTrackMetadataPerFetch {
                chat.tracksPages.append(tracksPage)
                tracksPage.removeAll()
            }
        }
        if !tracksPage.isEmpty {
            chat.tracksPages.append(tracksPage)
        }
        
        chat.hasFetchedTracksIDs = true
        chat.isFetchingTrackIDs = false
        
        self.objectWillChange.send()
    }

    //this trackID corresponds to the one passed in through 'onAppear'
    //we then use this value to synthesize the page of data that should be fetched
    func fetchTracksMetadata(for chat: Chat, spotifyID: String) {
        let page = chat.getPage(for: spotifyID)
        
        guard !chat.trackMetadataPagesBeingFetched.contains(page) && !chat.trackMetadataPagesFetched.contains(page) else {
            return
        }
        
        chat.trackMetadataPagesBeingFetched.append(page)
        
        let tracksMetadataToFetch = chat.getTracks(for: page)
        
        Task {
            let fetchedTracksMetadata = (try? await SpotifyManager.fetchTrackMetadata(for: tracksMetadataToFetch)) ?? []

            for (index, track) in fetchedTracksMetadata.enumerated() {
                chat.tracksPages[page][index] = track
            }
            
            DispatchQueue.main.async {
                chat.trackMetadataPagesFetched.append(page)
                chat.trackMetadataPagesBeingFetched.removeAll(where: { $0 == page })
                
                self.objectWillChange.send()
            }
        }
    }
    
    func createPlaylistAndAddSongs(
        desiredPlaylistName: String,
        chat: Chat
    ) async {
        let playlistID = await SwiftPythonInterface.createPlaylistAndAddSongs(
            playlistName: desiredPlaylistName,
            chatIDs: chat.ids
        )
        
        chat.playlistID = playlistID
        
        self.objectWillChange.send()
    }
    
    func resetModel() async {
        individualChats = []
        groupChats = []

        selectedIndividualChat = nil
        selectedGroupChat = nil

        await fetchChats()
    }
}
