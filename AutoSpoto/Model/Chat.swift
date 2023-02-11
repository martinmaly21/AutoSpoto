//
//  Chat.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct Chat: Hashable {
    enum ChatType {
        case individual(firstName: String?, lastName: String?)
        case group(name: String?)
    }

    let type: ChatType
    let image: String //base 64 string I believe
    let id: Int

    //this indicates whether a playlist already exists for this chat
    var playlistExists: Bool

    var tracks: [URL] = []

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

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
