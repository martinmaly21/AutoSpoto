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
    
    @Published var isFetchingIndividualChats = false
    @Published var isFetchingGroupChats = false
    
    public var isFetchingChats: Bool {
        return isFetchingIndividualChats || isFetchingGroupChats
    }

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
        DatabaseManager.shared = DatabaseManager()
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
        guard !isFetchingGroupChats else { return }
        isFetchingGroupChats = true
        
        defer {
            isFetchingGroupChats = false
        }

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
        guard !isFetchingIndividualChats else { return }
        isFetchingIndividualChats = true
        
        defer {
            isFetchingIndividualChats = false
        }
        
        self.individualChats = await DatabaseManager.shared.fetchIndividualChats()
        
        selectedIndividualChat = individualChats.first
    }
    
    func fetchTracks(for chat: Chat) async {
        //MARK: - first fetch track IDs to show row count
        guard !chat.hasFetchedTracksIDs && !chat.isFetchingTrackIDs else { return }
        
        chat.isFetchingTrackIDs = true
        
        let tracksWithNoMetadata = await DatabaseManager.shared.fetchSpotifyTracksWithNoMetadata(for: chat.ids)
        
        chat.tracksPages = tracksWithNoMetadata.splitIntoChunks(of: chat.numberOfTrackMetadataPerFetch)
        
        chat.hasFetchedTracksIDs = true
        chat.isFetchingTrackIDs = false
        
        self.objectWillChange.send()
        
        //then, fetch first page of metadata
        await fetchTracksMetadata(for: chat)
    }

    //this trackID corresponds to the one passed in through 'onAppear'
    //we then use this value to synthesize the page of data that should be fetched
    func fetchTracksMetadata(for chat: Chat, spotifyID: String? = nil) async {
        guard let page = chat.getPage(for: spotifyID),
              !chat.trackMetadataPagesBeingFetched.contains(page) && !chat.trackMetadataPagesFetched.contains(page) else {
            return
        }
        
        chat.trackMetadataPagesBeingFetched.append(page)
        
        let tracksMetadataToFetch = chat.getTracks(for: page)
        
        let fetchedTracksMetadata = (try? await SpotifyManager.fetchTrackMetadata(for: tracksMetadataToFetch)) ?? []
        
        for (index, track) in fetchedTracksMetadata.enumerated() {
            chat.tracksPages[page][index] = track
        }
        
        chat.trackMetadataPagesFetched.append(page)
        chat.trackMetadataPagesBeingFetched.removeAll(where: { $0 == page })
        
        self.objectWillChange.send()
    }
    
    func createPlaylistAndAddSongs(
        chat: Chat,
        desiredPlaylistName: String
    ) async throws {
        //re-fetch tracks, just in case there were ones that were added since
        await fetchTracks(for: chat)
        
        try await SpotifyManager.createPlaylistAndAddTracks(
            for: chat,
            desiredPlaylistName: desiredPlaylistName
        )
        
        self.objectWillChange.send()
    }
    
    func updatePlaylist(
        for chat: Chat
    ) async {
        //re-fetch tracks, just in case there were ones that were added since
        await fetchTracks(for: chat)
        
        do {
            try await SpotifyManager.updatePlaylist(for: chat)
        } catch let error {
            //TODO: handle if update playlist fails
        }
       
        
        self.objectWillChange.send()
    }
    
    func fetchPlaylist(
        for chat: Chat
    ) async {
        guard let spotifyPlaylistID = chat.spotifyPlaylistID else {
            fatalError("Could not get spotifyPlaylistID")
        }
        do {
            chat.spotifyPlaylist = try await SpotifyManager.fetchPlaylist(for: spotifyPlaylistID)
        } catch let error {
            //TODO: handle if fetch for playlist fails
        }
        
        self.objectWillChange.send()
    }
    
    func disconnectPlaylist(
        for chat: Chat
    ) async {
        #warning("Need to update autospoto.db")
        chat.spotifyPlaylistID = nil
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
