//
//  Chat.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct Chat: Hashable {
    let type: ChatType
    let image: String? //base 64 string I believe
    let id: Int

    //this indicates whether a playlist already exists for this chat
    var playlistExists: Bool

    var tracks: [Track] = []

    var hasFetchedTracks = false
    var isFetchingTracks = false
    var errorFetchingTracks = false

    var displayName: String {
        switch type {
        case .individual(let firstName, let lastName):
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            } else if let firstName = firstName {
                return firstName
            } else if let lastName = lastName {
                return lastName
            } else {
                fatalError("Individual chat has no name")
            }
        case .group(let name):
            if let name = name {
                return name
            } else {
                fatalError("Group chat has no name")
            }
        }
    }

    init(_ individualChatCodable: IndividualChatCodable) {
        type = .individual(
            firstName: individualChatCodable.First_Name,
            lastName: individualChatCodable.Last_Name
        )
        image = individualChatCodable.Image_Blob
        id = individualChatCodable.chat_id
        playlistExists = individualChatCodable.playlist_id
    }

    init(_ groupChatCodable: GroupChatCodable) {
        type = .group(name: groupChatCodable.display_name)
        image = nil //TODO
//        image = individualChatCodable.Image_Blob
        id = groupChatCodable.chat_id
        playlistExists = groupChatCodable.playlist_id
    }

    mutating func fetchTracks() async {
        guard !hasFetchedTracks && !isFetchingTracks else { return }

        hasFetchedTracks = true
        isFetchingTracks = true

        do {
            //TODO: fetch from SwiftPythonInterface
            let trackURLs: [URL]
            switch id {
            case 0:
                trackURLs = [
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
                trackURLs = [
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
                ]
            case 2:
                trackURLs = [
                    URL(string: "https://open.spotify.com/track/5ih10ZfcZ2J0tml5xaKsZR?si=b4382f6f42e2441b")!,
                    URL(string: "https://open.spotify.com/track/1WsHKAuN9vDthcmimdqqaY?si=4f04137a124e47e2")!,
                    URL(string: "https://open.spotify.com/track/1YzEaZWQHeEGAQADZFA1of?si=2619369cfd344986")!,
                ]
            default:
                trackURLs = []
            }


            tracks = trackURLs.map { Track(url: $0, timeStamp: 0) }

            isFetchingTracks = false
        } catch let error {
            isFetchingTracks = false
            errorFetchingTracks = true
        }
    }

    func fetchMetadataForTracks(completion: @escaping (Track) -> Void) {
        for (index, track) in tracks.reversed().enumerated() {
            DispatchQueue.main.asyncAfter(
                //is this enough of a delay to avoid 'Too many requests' errors?
                deadline: .now() + (0.01 * Double(index)) ,
                execute: {
                    track.getTrackMetadata(completion: completion)
                }
            )
        }
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
