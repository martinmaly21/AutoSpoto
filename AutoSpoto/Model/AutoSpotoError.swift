//
//  AutoSpotoError.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

enum AutoSpotoError: LocalizedError {
    case unexpectedHTTPUrlResponse
    case errorLoggingInToSpotify
    case chatHasNoValidIDs
    case errorGettingAutoSpotoDB
    
    var errorDescription: String? {
        switch self {
        case .unexpectedHTTPUrlResponse:
            return AutoSpotoConstants.Strings.UNEXPECTED_RESPONSE
        case .errorLoggingInToSpotify:
            return AutoSpotoConstants.Strings.ERROR_LOGGING_INTO_SPOTIFY
        case .chatHasNoValidIDs:
            return AutoSpotoConstants.Strings.CHAT_HAS_NO_VALID_IDS
        case .errorGettingAutoSpotoDB:
            return AutoSpotoConstants.Strings.ERROR_GETTING_AUTOSPOTO_DB
        }
    }
}
