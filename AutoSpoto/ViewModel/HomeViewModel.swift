//
//  HomeViewModel.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var chats: [Chat] = []

    public func fetchChats() {
        //TODDO: fetch from SwiftPythonInterface
        self.chats = [
            Chat(image: "", name: "Family 🏠", chatID: 0, playlistExists: true),
            Chat(image: "", name: "House music", chatID: 1, playlistExists: true),
            Chat(image: "", name: "Johnny Sins 👨🏼‍🦲", chatID: 2, playlistExists: true),
            Chat(image: "", name: "Yerd Yanson", chatID: 3, playlistExists: false),
            Chat(image: "", name: "Adrian Bilic", chatID: 4, playlistExists: false),
            Chat(image: "", name: "Andrew Caravaggio", chatID: 5, playlistExists: true),
            Chat(image: "", name: "Mike Hunt 🍑", chatID: 6, playlistExists: true),
            Chat(image: "", name: "Alexander Shulgin 🍬", chatID: 7, playlistExists: false),
            Chat(image: "", name: "Tiger Woods", chatID: 8, playlistExists: false),
            Chat(image: "", name: "Dad", chatID: 9, playlistExists: true),
            Chat(image: "", name: "Barney", chatID: 10, playlistExists: true),
            Chat(image: "", name: "Moby 🐳", chatID: 11, playlistExists: false),
        ]
    }
}
