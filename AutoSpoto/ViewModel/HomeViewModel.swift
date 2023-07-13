//
//  HomeViewModel.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var chatSections: [ChatSection] = []
    @Published var selectedChat: Chat? {
        willSet {
            shouldScrollToBottom = true
        }
    }
    
    @Published var isFetchingChats = false
    @Published var shouldScrollToBottom = false
    
    @Published var connectedChatsIsExpanded = true
    @Published var chatsWithTracksIsExpanded = true
    @Published var chatsWithNoTracksIsExpanded = false

    init() {
        DatabaseManager.shared = DatabaseManager(
            onTrackedChatsDBUpdatedOutsideOfApp: {
                Task {
                    await self.fetchChats()
                }
            }
        )
    }

    public func fetchChats() async {
        guard !isFetchingChats else { return }
        isFetchingChats = true
        
        defer {
            isFetchingChats = false
        }

        let groupChats = await DatabaseManager.shared.fetchGroupChats()
        let individualChats = await DatabaseManager.shared.fetchIndividualChats()
        
        updateChatSections(allChats: groupChats + individualChats)
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
        
        do {
            guard let spotifyPlaylistID = chat.spotifyPlaylistID else {
                fatalError("Could not get spotifyPlaylistID from Chat")
            }
            let dateUpdated = try await SpotifyManager.updatePlaylist(
                spotifyPlaylistID: spotifyPlaylistID,
                tracks: chat.tracks,
                lastUpdated: chat.lastUpdated
            )
            chat.lastUpdated = dateUpdated
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
        guard let spotifyPlaylistID = chat.spotifyPlaylistID else {
            fatalError("Could not get spotifyPlaylistID for chat to remove")
        }
        DatabaseManager.shared.remove(spotifyPlaylistID)
        chat.spotifyPlaylistID = nil
        chat.lastUpdated = nil
        
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
        let connectedChatsWithContactsOrChatNames = connectedChats.filter { $0.hasContactOrChatName }
        let connectedChatsWithNoContactsOrChatNames = connectedChats.filter { !$0.hasContactOrChatName }
        let connectedChatsSection = ChatSection(
            title: AutoSpotoConstants.Strings.SPOTIFY_PLAYLIST_EXISTS_SECTION,
            chats: connectedChatsWithContactsOrChatNames + connectedChatsWithNoContactsOrChatNames
        )
        
        var chatsWithTracks = allChats.filter { $0.hasTracks && !$0.spotifyPlaylistExists }
        chatsWithTracks.sort(by: { $0.displayName < $1.displayName })
        let chatsWithTracksWithContactsOrChatNames = chatsWithTracks.filter { $0.hasContactOrChatName }
        let chatsWithTracksWithNoContactsOrChatNames = chatsWithTracks.filter { !$0.hasContactOrChatName }
        let chatsWithTrackSection = ChatSection(
            title: AutoSpotoConstants.Strings.CHATS_WITH_TRACKS,
            chats: chatsWithTracksWithContactsOrChatNames + chatsWithTracksWithNoContactsOrChatNames
        )
        
        var chatsWithNoTracks = allChats.filter { !$0.hasTracks && !$0.spotifyPlaylistExists }
        chatsWithNoTracks.sort(by: { $0.displayName < $1.displayName })
        let chatsWithNoTracksWithContactsOrChatNames = chatsWithNoTracks.filter { $0.hasContactOrChatName }
        let chatsWithNoTracksWithNoContactsOrChatNames = chatsWithNoTracks.filter { !$0.hasContactOrChatName }
        let chatsWithNoTrackSection = ChatSection(
            title: AutoSpotoConstants.Strings.CHATS_WITH_NO_TRACKS,
            chats: chatsWithNoTracksWithContactsOrChatNames + chatsWithNoTracksWithNoContactsOrChatNames
        )
        
        chatSections = [connectedChatsSection, chatsWithTrackSection, chatsWithNoTrackSection]
        
        if let updatedChat = updatedChat {
            selectedChat = updatedChat
        } else if let selectedChat = selectedChat {
            self.selectedChat = nil
            self.selectedChat = chatSections.flatMap { $0.chats }.first(where: { $0.ids == selectedChat.ids })
        } else {
            selectedChat = chatSections.flatMap { $0.chats }.first
        }
    }
    
    func resetModel() async {
        chatSections = []

        await fetchChats()
    }
}
