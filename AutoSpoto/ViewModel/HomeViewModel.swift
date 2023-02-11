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
    }

    public func fetchTracks(for chat: Chat) {
        var chatToUpdate = chat

        //TODO: fetch from SwiftPythonInterface
        let chatTracks: [URL]
        switch chat.id {
        case 0:
            chatTracks = [
                URL(string: "https://open.spotify.com/track/786ymAh5BmHoIpvjyrvjXk?si=803ddae92ebb468a")!,
                URL(string: "https://open.spotify.com/track/3UyM4nviJQhxibP1O1f5FD?si=251fd138d78f409a")!,
                URL(string: "https://open.spotify.com/track/6cB6vtflgNQYaC8JDrxUps?si=e8efcdf2a404420c")!,
                URL(string: "https://open.spotify.com/track/3qOuySPLpVyBXLuTNMgbRj?si=40f052fdb07f4b90")!,
                URL(string: "https://open.spotify.com/track/2OBnKKfUuxQcQ5qbrIojem?si=eb126fd9791f4893")!,
                URL(string: "https://open.spotify.com/track/2oWFFtOQx0Qh31L89ybK8c?si=17ef50e9696e41f9")!,
                URL(string: "https://open.spotify.com/track/6rAnjfvnJs5tNzE8kjZJWI?si=7eb9d59801604ec1")!,
                URL(string: "https://open.spotify.com/track/1j1tTelvaHbmRsxsApzVM6?si=7f267cf8fb8e4c74")!,
                URL(string: "https://open.spotify.com/track/5NsruZ9uIydV0A196WZjkV?si=6f0631c1b9fb4d7e")!,
                URL(string: "https://open.spotify.com/track/09lzbPVfBU99ITkfQoizj0?si=0ad836e77f6949e0")!,
                URL(string: "https://open.spotify.com/track/3C1GqgV9WFcJqjALF5eUXW?si=e8ec556432444c2f")!,
                URL(string: "https://open.spotify.com/track/2XyNLoEWc4IDt9OVzXZUXl?si=869654386f434637")!,
                URL(string: "https://open.spotify.com/track/0SZJ7HnPHg4bBHtoJdgAkI?si=6016a509033f4a7f")!,
                URL(string: "https://open.spotify.com/track/4oyQ6vDzJMFYhmO9p5qrjE?si=f66fc9db6da34fd4")!,
                URL(string: "https://open.spotify.com/track/2MciXM60hrG1cz5DE7ZWzK?si=b7528a3f90fe4825")!,
                URL(string: "https://open.spotify.com/track/0P4rQjZWWeor9Mzr0SMnK9?si=6d10c543741749fa")!,
                URL(string: "https://open.spotify.com/track/1EWsVHU4FNAdtN4R8FETag?si=9832c723114e4c50")!,
                URL(string: "https://open.spotify.com/track/4PCIUCi6kRm91LRwWYHWYY?si=0c81d6b4a2d2421d")!,
            ]
        case 1:
            chatTracks = [
                URL(string: "https://open.spotify.com/track/786ymAh5BmHoIpvjyrvjXk?si=803ddae92ebb468a")!,
                URL(string: "https://open.spotify.com/track/4odwbuSOiv6KEv6uAEZl4x?si=78e5956ac45245f4")!,
                URL(string: "https://open.spotify.com/track/6SiDlN4LfZNqm9ZrWHltrO?si=7ea2a82498604dd1")!,
                URL(string: "https://open.spotify.com/track/07KAToiEVIKU7WvXkoTWQR?si=c1ff8bea32d34119")!,
                URL(string: "https://open.spotify.com/track/5c30Lqd4zY3dpMK2usb9yU?si=cdfdac10c5584c44")!,
                URL(string: "https://open.spotify.com/track/64Eji6WqA3iHTwAa9DzZll?si=7905c240950b4634")!,
                URL(string: "https://open.spotify.com/track/30cjLreSF4Xq0uAB89i2Ac?si=892c2543b6cd4f76")!,
                URL(string: "https://open.spotify.com/track/44dFOGFKVgNrx6UilTRVfZ?si=386ef200195f418e")!,
                URL(string: "https://open.spotify.com/track/3bkp4cJmB2pkVS6NWRi0T2?si=4fd2311bf866447b")!,
                URL(string: "https://open.spotify.com/track/3eSmjY0PxxTlX6UxRDKaul?si=841e314772c84519")!,
                URL(string: "https://open.spotify.com/track/42iMXyOvLeD2vKu7ZlREVh?si=ebd0dc81d69b438e")!,
                URL(string: "https://open.spotify.com/track/3t6VsjenwUKGlMPlGDhR47?si=699b5b4310614d2f")!,
                URL(string: "https://open.spotify.com/track/1TIiWomS4i0Ikaf9EKdcLn?si=880eb8d3c0d44842")!,
                URL(string: "https://open.spotify.com/track/7AkuWVEfviEjaNa8ps3uVw?si=9af92ac3fc934610")!,
                URL(string: "https://open.spotify.com/track/0VdUEzckZmEeASNPXGxiXO?si=dce8159d9f314e52")!,
                URL(string: "https://open.spotify.com/track/5ih10ZfcZ2J0tml5xaKsZR?si=b4382f6f42e2441b")!,
                URL(string: "https://open.spotify.com/track/1WsHKAuN9vDthcmimdqqaY?si=4f04137a124e47e2")!,
                URL(string: "https://open.spotify.com/track/1YzEaZWQHeEGAQADZFA1of?si=2619369cfd344986")!,
            ]
        default:
            chatTracks = []
        }

        chatToUpdate.tracks = chatTracks

        guard let chatIndex = chats.firstIndex(of: chat) else {
            fatalError("Could not get chat index")
        }

        chats[chatIndex] = chatToUpdate
        self.chats = chats
    }
}
