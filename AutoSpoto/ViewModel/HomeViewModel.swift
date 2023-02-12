//
//  HomeViewModel.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var selectedChatIndex: Int?

    @Published var isFetchingChats = false

    public func fetchChats() async {
        defer {
            isFetchingChats = false
        }

        isFetchingChats = true

        //TODO: fetch from SwiftPythonInterface
        self.chats = [
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
            Chat(
                type: .group(name: "Colombia Crew"),
                image: "",
                id: 11,
                playlistExists: false
            )
        ]

        selectedChatIndex = 0
    }

    public func fetchTracks(for chat: Chat) async {
        var chatToUpdate = chat

        await chatToUpdate.fetchTracks()

        updateChats(chat: chat, chatToUpdate: chatToUpdate)

        await chatToUpdate.fetchMetadataForTracks()

        updateChats(chat: chat, chatToUpdate: chatToUpdate)
    }


    private func updateChats(chat: Chat, chatToUpdate: Chat) {
        guard let chatIndex = chats.firstIndex(of: chat) else {
            fatalError("Could not get chat index")
        }

        chats[chatIndex] = chatToUpdate
        self.chats = chats
    }
}
