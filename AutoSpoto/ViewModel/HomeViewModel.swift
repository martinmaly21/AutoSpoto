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

        //TODO: fetch from SwiftPythonInterface
        groupChats = [
            Chat(
                type: .group(name: "Family 🏠"),
                image: "",
                id: 0,
                playlistExists: true
            ),
            Chat(
                type: .group(name: "House music"),
                image: "",
                id: 1,
                playlistExists: true
            ),
            Chat(
                type: .group(name: "Colombia Crew"),
                image: "",
                id: 11,
                playlistExists: false
            )
        ]

        selectedGroupChatIndex = 0
    }

    private func fetchIndividualChats() async {
        //only fetch if individual chats have not already been fetched (individualChats.isEmpty)
        guard individualChats.isEmpty else { return }

        //TODO: fetch from SwiftPythonInterface
        individualChats = [
            Chat(
                type: .individual(firstName: "Johnny", lastName: "Sins"),
                image: "",
                id: 2,
                playlistExists: false
            ),
            Chat(
                type: .individual(firstName: "Yerd", lastName: "Yanson"),
                image: "",
                id: 3,
                playlistExists: true
            ),
            Chat(
                type: .individual(firstName: "Andrew", lastName: "Caravaggio"),
                image: "",
                id: 4,
                playlistExists: false
            ),
            Chat(
                type: .individual(firstName: "Adrian", lastName: "Bilic"),
                image: "",
                id: 5,
                playlistExists: false
            ),
            Chat(
                type: .individual(firstName: "Mike", lastName: "Hunt 🍑"),
                image: "",
                id: 6,
                playlistExists: false
            ),
            Chat(
                type: .individual(firstName: "Alexander", lastName: "Shulgin 🍬"),
                image: "",
                id: 7,
                playlistExists: false
            ),
            Chat(
                type: .individual(firstName: "Tiger", lastName: "Woods"),
                image: "",
                id: 8,
                playlistExists: false
            ),
            Chat(
                type: .individual(firstName: "Dad", lastName: nil),
                image: "",
                id: 9,
                playlistExists: false
            ),
            Chat(
                type: .individual(firstName: "Barney", lastName: "Maly 🐶"),
                image: "",
                id: 10,
                playlistExists: false
            ),
        ]

        selectedIndividualChatIndex = 0
    }

    public func fetchTracksForIndividualChat() async {
        guard let selectedIndividualChatIndex = selectedIndividualChatIndex else {
            return
        }

        await individualChats[selectedIndividualChatIndex].fetchTracks()

        individualChats[selectedIndividualChatIndex].fetchMetadataForTracks(completion: { updatedTrack in
            if let indexOfTrack = self.individualChats[selectedIndividualChatIndex].tracks.firstIndex(of: updatedTrack) {
                DispatchQueue.main.async {
                    self.individualChats[selectedIndividualChatIndex].tracks[indexOfTrack] = updatedTrack
                }
            }
        })
    }

    public func fetchTracksForGroupChat() async {
        guard let selectedGroupChatIndex = selectedGroupChatIndex else {
            return
        }

        await groupChats[selectedGroupChatIndex].fetchTracks()

        groupChats[selectedGroupChatIndex].fetchMetadataForTracks(completion: { updatedTrack in
            if let indexOfTrack = self.groupChats[selectedGroupChatIndex].tracks.firstIndex(of: updatedTrack) {
                DispatchQueue.main.async {
                    self.groupChats[selectedGroupChatIndex].tracks[indexOfTrack] = updatedTrack
                }
            }
        })
    }
}
