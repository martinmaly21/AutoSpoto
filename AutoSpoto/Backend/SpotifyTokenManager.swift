//
//  SpotifyTokenManager.swift
//  AutoSpoto
//
//  Created by Andrew Caravaggio on 2023-07-07.
//

import Foundation


class SpotifyTokenManager{
    static func writeToken(spotifyToken: SpotifyToken) {
        let jsonToken = JSONToken(spotifyToken: spotifyToken)
        let jsonEncoder = JSONEncoder()
        
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            
            do {
                let jsonData = try jsonEncoder.encode(jsonToken)
                try jsonData.write(to: directoryURL)
            } catch {
                fatalError("Error writing JSON token: \(error.localizedDescription)")
            }
        }
    }
    
    static func readToken() -> JSONToken? {
        let decoder = JSONDecoder()
        
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            
            do {
                let data = try Data(contentsOf: directoryURL)
                let JSONToken = try decoder.decode(JSONToken.self, from: data)
                return JSONToken
            } catch {
                return nil
            }
        }
        return nil
    }
    
    static func deleteToken() {
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            do {
                try FileManager.default.removeItem(at: directoryURL)
            } catch let error {
                fatalError("Error deleting JSON token: \(error.localizedDescription)")
            }
        }
    }
    
    public static var authenticationTokenExists: Bool {
        return readToken() != nil
    }
}
