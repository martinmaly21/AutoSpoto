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
    
    func resetModel() async {
        individualChats = []
        groupChats = []

        selectedIndividualChat = nil
        selectedGroupChat = nil

        await fetchChats()
    }
}
