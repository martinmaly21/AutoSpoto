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
    
    let databaseManager: DatabaseManager

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
    
    init() {
        #warning("Will need to update")
        let databaseString = "/Users/martinmaly/Developer/AutoSpoto/AutoSpoto/Backend/autospoto.db"
        let addressBookID = "0E0A58CC-863C-47F3-9C70-A81612E240C4"
        databaseManager = DatabaseManager(databaseString: databaseString, addressBookID: addressBookID)
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

        let groupChatsJSON = databaseManager.fetchGroupChats()

        do {
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([GroupChatCodable].self, from: groupChatsJSON)
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

        let indivualChatsJSON = databaseManager.fetchIndividualChats()
        
        do {
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([IndividualChatCodable].self, from: indivualChatsJSON)
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

//        await individualChats[selectedIndividualChatIndex].fetchTracksWithNoMetadata()
//        await individualChats[selectedIndividualChatIndex].fetchTracksWithMetadata()
    }

    public func fetchTracksForGroupChat() async {
        guard let selectedGroupChatIndex = selectedGroupChatIndex else {
            return
        }

        await groupChats[selectedGroupChatIndex].fetchTracksWithNoMetadata()
        await groupChats[selectedGroupChatIndex].fetchTracksWithMetadata()
    }

    public func updateChatForPlaylist(
        chat: Chat,
        playlistID: String
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
