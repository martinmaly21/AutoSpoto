//
//  AutoSpotoConstants+HTTPParameter.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

extension AutoSpotoConstants {
    struct HTTPParameter {
        private init() {}
    }
}

extension AutoSpotoConstants.HTTPParameter {
    static let grant_type = "grant_type"
    static let redirect_uri = "redirect_uri"
    static let code = "code"
    static let refresh_token = "refresh_token"
}
