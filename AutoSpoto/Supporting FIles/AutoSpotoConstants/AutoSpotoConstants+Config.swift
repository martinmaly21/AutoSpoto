//
//  AutoSpotoConstants+Config.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2024-04-30.
//

import Foundation


extension AutoSpotoConstants {
    struct Config {
        private init() {}
    }
}

extension AutoSpotoConstants.Config {
    static var developmentTeam: String {
        return getInfoPlistValue(for: "DEVELOPMENT_TEAM")
    }

    //random string used to encrypt license file
    static var spotifyClientID: String {
        return getInfoPlistValue(for: "SPOTIFY_CLIENT_ID")
    }
    
    static var spotifyClientSecret: String {
        return getInfoPlistValue(for: "SPOTIFY_CLIENT_SECRET")
    }
    
    static var lFile: String {
        return getInfoPlistValue(for: "L_FILE")
    }
    
    static func getInfoPlistValue(for key: String) -> String {
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { fatalError() }
        guard let keyValue: String = infoDictionary[key] as? String else { fatalError() }
        return keyValue
    }
}


