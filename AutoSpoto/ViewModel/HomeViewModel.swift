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

    @Published var selectedIndividualChatIndex: Int?
    @Published var selectedGroupChatIndex: Int?

    @Published var filterSelection: FilterChatType = .individual

    @Published var scrollToBottom = false

    var selectedChatIndex: Int? {
        get {
            switch filterSelection {
            case .individual:
                return selectedIndividualChatIndex
            case .group:
                return selectedGroupChatIndex
            }
        }

        set {
            switch filterSelection {
            case .individual:
                selectedIndividualChatIndex = newValue
            case .group:
                selectedGroupChatIndex = newValue
            }

            scrollToBottom = true
        }
    }

    var selectedChat: Chat? {
        guard let selectedChatIndex = selectedChatIndex else {
            return nil
        }

        switch filterSelection {
        case .individual:
            return individualChats[selectedChatIndex]
        case .group:
            return groupChats[selectedChatIndex]
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

        let jsonString = SwiftPythonInterface.viewGroupChat().description
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Could not get jsonData")
        }

        do {
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([GroupChatCodable].self, from: jsonData)
            groupChats = tableData.map { Chat($0) }
        }
        catch {
            //TODO: handle error better
            print (error)
        }

        selectedGroupChatIndex = 0
    }

    private func fetchIndividualChats() async {
        //only fetch if individual chats have not already been fetched (individualChats.isEmpty)
        guard individualChats.isEmpty else { return }

        let jsonString = SwiftPythonInterface.viewSingleChat().description
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Could not get jsonData")
        }

        do {
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([IndividualChatCodable].self, from: jsonData)
            individualChats = tableData.map { Chat($0) }
        }
        catch {
            //TODO: handle error better
            print (error)
        }

        selectedIndividualChatIndex = 0
    }

    public func fetchTracksForIndividualChat() async {
        guard let selectedIndividualChatIndex = selectedIndividualChatIndex else {
            return
        }

        await individualChats[selectedIndividualChatIndex].fetchTracks()
    }

    public func fetchTracksForGroupChat() async {
        guard let selectedGroupChatIndex = selectedGroupChatIndex else {
            return
        }

        await groupChats[selectedGroupChatIndex].fetchTracks()
    }

    public func cancelTrackMetadataFetchIfNeeded(
        chat: Chat,
        track: Track
    ) {
        switch filterSelection {
        case .individual:
            cancelTrackMetadataFetchIfNeededForIndividualChat(chat: chat, track: track)
        case .group:
            cancelTrackMetadataFetchIfNeededForGroupChat(chat: chat, track: track)
        }
    }

    private func cancelTrackMetadataFetchIfNeededForIndividualChat(
        chat: Chat,
        track: Track
    ) {
        if let indexOfChat = individualChats.firstIndex(of: chat),
           let indexOfTrack = individualChats[indexOfChat].tracks.firstIndex(of: track) {
            individualChats[indexOfChat].tracks[indexOfTrack].cancelTaskIfNeeded()
        }
    }

    private func cancelTrackMetadataFetchIfNeededForGroupChat(
        chat: Chat,
        track: Track
    ) {
        if let indexOfChat = groupChats.firstIndex(of: chat),
           let indexOfTrack = groupChats[indexOfChat].tracks.firstIndex(of: track) {
            groupChats[indexOfChat].tracks[indexOfTrack].cancelTaskIfNeeded()
        }
    }

    public func fetchTrackMetadata(
        chat: Chat,
        track: Track
    ) async {
        switch filterSelection {
        case .individual:
            await fetchTrackMetadataForIndividualChat(chat: chat, track: track)
        case .group:
            await fetchTrackMetadataForGroupChat(chat: chat, track: track)
        }
    }

    private func fetchTrackMetadataForIndividualChat(
        chat: Chat,
        track: Track
    ) async {
        if let indexOfChat = individualChats.firstIndex(of: chat),
           let indexOfTrack = individualChats[indexOfChat].tracks.firstIndex(of: track) {
            individualChats[indexOfChat].tracks[indexOfTrack].fetchTrackMetadata { updatedTrack in
                DispatchQueue.main.async {
                    self.individualChats[indexOfChat].tracks[indexOfTrack] = updatedTrack
                }
            }
        }
    }

    private func fetchTrackMetadataForGroupChat(
        chat: Chat,
        track: Track
    ) async {
        if let indexOfChat = groupChats.firstIndex(of: chat),
           let indexOfTrack = groupChats[indexOfChat].tracks.firstIndex(of: track) {
            groupChats[indexOfChat].tracks[indexOfTrack].fetchTrackMetadata { updatedTrack in
                DispatchQueue.main.async {
                    self.groupChats[indexOfChat].tracks[indexOfTrack] = updatedTrack
                }
            }
        }
    }

    public func updateChatForPlaylist(
        chat: Chat,
        playlistID: Int
    ) {
        switch filterSelection {
        case .individual:
            if let indexOfChat = individualChats.firstIndex(of: chat) {
                self.individualChats[indexOfChat].playlistID = playlistID
            }
        case .group:
            if let indexOfChat = groupChats.firstIndex(of: chat) {
                self.groupChats[indexOfChat].playlistID = playlistID
            }
        }
    }
    
    func resetModel() async {
        individualChats = []
        groupChats = []

        selectedIndividualChatIndex = nil
        selectedGroupChatIndex = nil

        await fetchChats()
    }
}
