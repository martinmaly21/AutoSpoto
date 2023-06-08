//
//  AutoSpotoConstants+HTTPStatus.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

extension AutoSpotoConstants {
    struct HTTPStatus {
        private init() {}
    }
}

extension AutoSpotoConstants.HTTPStatus {
    static let ok = 200
    static let created = 201
    static let accepted = 202
    static let noContent = 204
    static let movedPermanently = 301
    static let found = 302
    static let movedTemporarily = 303
    static let temporaryRedirect = 307
    static let permanentRedirect = 308
}
