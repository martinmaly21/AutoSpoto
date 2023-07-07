//
//  HomeViewModel.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published private var individualChatSections: [ChatSection] = []
    @Published private var groupChatSections: [ChatSection] = []

    @Published private var selectedIndividualChat: Chat?
    @Published private var selectedGroupChat: Chat?

    @Published var filterSelection: FilterChatType = .individual
    
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
        }
    }

    var chatSections: [ChatSection] {
        get {
            switch filterSelection {
            case .individual:
                return individualChatSections
            case .group:
                return groupChatSections
            }
        }
        
        set {
            switch filterSelection {
            case .individual:
                individualChatSections = newValue
            case .group:
                groupChatSections = newValue
            }
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
        
        let groupChats = await DatabaseManager.shared.fetchGroupChats()
        updateChatSections(allChats: groupChats)
    }

    private func fetchIndividualChats() async {
        //only fetch if individual chats have not already been fetched (individualChats.isEmpty)
        guard !isFetchingIndividualChats else { return }
        isFetchingIndividualChats = true
        
        defer {
            isFetchingIndividualChats = false
        }
        
        let individualChats = await DatabaseManager.shared.fetchIndividualChats()
        updateChatSections(allChats: individualChats)
    }
    
    private func fetchTracks(for chat: Chat) async {
        let tracksWithNoMetadata = await DatabaseManager.shared.fetchSpotifyTracksWithNoMetadata(for: chat.ids)
        chat.tracksPages = tracksWithNoMetadata.splitIntoChunks(of: chat.numberOfTrackMetadataPerFetch)
        
        chat.trackMetadataPagesBeingFetched = []
        chat.trackMetadataPagesFetched = []
        
        self.objectWillChange.send()
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
        
        updateChatSections(allChats: chatSections.flatMap { $0.chats }, updatedChat: chat)
        
        self.objectWillChange.send()
    }
    
    func updatePlaylist(
        for chat: Chat
    ) async {
        //re-fetch tracks, just in case there were ones that were added since
        await fetchTracks(for: chat)
        print("HEre")
        
        do {
            try await SpotifyManager.updatePlaylist(for: chat)
        } catch let error {
            //TODO: handle if update playlist fails
        }
       
        //update chat sections
        updateChatSections(allChats: chatSections.flatMap { $0.chats }, updatedChat: chat)
        
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
        
        updateChatSections(allChats: chatSections.flatMap { $0.chats }, updatedChat: chat)
        
        self.objectWillChange.send()
    }
    
    //this is called whenever a user updates a chat, since it may be moved to a different section
    //the sitations i can think of
    //1. a user disconnects a chat, so it should be moved to either 'chats with tracks' or 'chats with no tracks'
    //2. a user connects a chat, so it should be moved to 'connected chats'
    private func updateChatSections(allChats: [Chat], updatedChat: Chat? = nil) {
        var connectedChats = allChats.filter { $0.spotifyPlaylistExists }
        connectedChats.sort(by: { $0.displayName < $1.displayName })
        let connectedChatsNames = connectedChats.filter { $0.displayName.digits != $0.displayName }
        let connectedChatsNumbers = connectedChats.filter { $0.displayName.digits == $0.displayName }
        let connectedChatsSection = ChatSection(
            title: AutoSpotoConstants.Strings.SPOTIFY_PLAYLIST_EXISTS_SECTION,
            chats: connectedChatsNames + connectedChatsNumbers
        )
        
        var chatsWithTracks = allChats.filter { $0.hasTracks && !$0.spotifyPlaylistExists }
        chatsWithTracks.sort(by: { $0.displayName < $1.displayName })
        let chatsWithTracksNames = chatsWithTracks.filter { $0.displayName.digits != $0.displayName }
        let chatsWithTracksNumbers = chatsWithTracks.filter { $0.displayName.digits == $0.displayName }
        let chatsWithTrackSection = ChatSection(
            title: AutoSpotoConstants.Strings.CHATS_WITH_TRACKS,
            chats: chatsWithTracksNames + chatsWithTracksNumbers
        )
        
        var chatsWithNoTracks = allChats.filter { !$0.hasTracks && !$0.spotifyPlaylistExists }
        chatsWithNoTracks.sort(by: { $0.displayName < $1.displayName })
        let chatsWithNoTracksNames = chatsWithNoTracks.filter { $0.displayName.digits != $0.displayName }
        let chatsWithNoTracksNumbers = chatsWithNoTracks.filter { $0.displayName.digits == $0.displayName }
        let chatsWithNoTrackSection = ChatSection(
            title: AutoSpotoConstants.Strings.CHATS_WITH_NO_TRACKS,
            chats: chatsWithNoTracksNames + chatsWithNoTracksNumbers
        )
        
        chatSections = [connectedChatsSection, chatsWithTrackSection, chatsWithNoTrackSection]
        
        if let updatedChat = updatedChat {
            selectedChat = updatedChat
        } else {
            selectedChat = chatSections.flatMap { $0.chats }.first
        }
    }
    
    func resetModel() async {
        individualChatSections = []
        groupChatSections = []

        selectedIndividualChat = nil
        selectedGroupChat = nil

        await fetchChats()
    }
}
