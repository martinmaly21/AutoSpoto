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
            Chat(image: "", name: "Family 🏠", chatID: 0),
            Chat(image: "", name: "House music", chatID: 1),
            Chat(image: "", name: "Johnny Sins 👨🏼‍🦲", chatID: 2),
            Chat(image: "", name: "Yerd Yanson", chatID: 3),
            Chat(image: "", name: "Adrian Bilic", chatID: 4),
            Chat(image: "", name: "Andrew Caravaggio", chatID: 5),
            Chat(image: "", name: "Mike Hunt 🍑", chatID: 6),
            Chat(image: "", name: "Alexander Shulgin 🍬", chatID: 7),
            Chat(image: "", name: "Tiger Woods", chatID: 8),
            Chat(image: "", name: "Dad", chatID: 9),
            Chat(image: "", name: "Barney", chatID: 10),
            Chat(image: "", name: "Moby 🐳", chatID: 11),
        ]
    }
}
