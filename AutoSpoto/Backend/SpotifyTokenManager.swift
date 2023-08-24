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
        
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            
            do {
                let data = try Data(contentsOf: directoryURL)
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
        
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            
            do {
                let jsonData = try jsonEncoder.encode(jsonToken)
                let encryptedData = RNCryptor.encrypt(data: jsonData, withPassword: lFile)
                try encryptedData.write(to: directoryURL)
            } catch {
                fatalError("Error writing JSON token: \(error.localizedDescription)")
            }
        }
    }
    
    public static func deleteToken() {
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            do {
                try FileManager.default.removeItem(at: directoryURL)
            } catch let error {
                print("Error deleting JSON token: \(error.localizedDescription)")
            }
        }
    }
}
