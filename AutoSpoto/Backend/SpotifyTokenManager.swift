//
//  SpotifyTokenManager.swift
//  AutoSpoto
//
//  Created by Andrew Caravaggio on 2023-07-07.
//

import Foundation
import RNCryptor


class SpotifyTokenManager {
    public static var authenticationTokenExists: Bool {
        return token != nil
    }
    
    public static var token: JSONToken? {
        let decoder = JSONDecoder()
        
        let fileManager = FileManager.default
        if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            do {
                let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto")
                try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                let spotifyTokenURL = directoryURL.appendingPathComponent("spotifyToken.json")
                
                let data = try Data(contentsOf: spotifyTokenURL)
                let decryptedData = try RNCryptor.decrypt(data: data, withPassword: lFile)
                let JSONToken = try decoder.decode(JSONToken.self, from: decryptedData)
                return JSONToken
            } catch {
                return nil
            }
        }
        return nil
    }
    
    public static func writeToken(spotifyToken: SpotifyToken) {
        let jsonToken = JSONToken(spotifyToken: spotifyToken)
        let jsonEncoder = JSONEncoder()
        
        let fileManager = FileManager.default
        if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            do {
                let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto")
                try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                let spotifyTokenURL = directoryURL.appendingPathComponent("spotifyToken.json")
                
                let jsonData = try jsonEncoder.encode(jsonToken)
                let encryptedData = RNCryptor.encrypt(data: jsonData, withPassword: lFile)
                try encryptedData.write(to: spotifyTokenURL)
            } catch {
                fatalError("Error writing JSON token: \(error.localizedDescription)")
            }
        }
    }
    
    public static func deleteToken() {
        let fileManager = FileManager.default
        if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            do {
                let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto")
                try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                let spotifyTokenURL = directoryURL.appendingPathComponent("spotifyToken.json")
                
                try fileManager.removeItem(at: spotifyTokenURL)
            } catch let error {
                print("Error deleting JSON token: \(error.localizedDescription)")
            }
        }
    }
}
