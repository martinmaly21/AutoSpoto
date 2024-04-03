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
        do {
            guard let spotifyTokenURL = DiskAccessManager.spotifyTokenURL else {
                return nil
            }
            DiskAccessManager.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: spotifyTokenURL)
            DiskAccessManager.stopAccessingSecurityScopedResource()
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: lFile)
            let JSONToken = try decoder.decode(JSONToken.self, from: decryptedData)
            return JSONToken
        } catch let error {
            return nil
        }
    }
    
    public static func writeToken(spotifyToken: SpotifyToken) {
        let jsonToken = JSONToken(spotifyToken: spotifyToken)
        let jsonEncoder = JSONEncoder()

        
        do {
            let jsonData = try jsonEncoder.encode(jsonToken)
            let encryptedData = RNCryptor.encrypt(data: jsonData, withPassword: lFile)
            
            if let groupContainerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AutoSpotoConstants.UserDefaults.group_name){
                let AutoSpotoDir = groupContainerUrl.appendingPathComponent("AutoSpoto")
                try? FileManager.default.createDirectory(at: AutoSpotoDir, withIntermediateDirectories: false, attributes: nil)
            }
            
            if let spotifyTokenURL = DiskAccessManager.spotifyTokenURL {
                print(spotifyTokenURL)
                DiskAccessManager.startAccessingSecurityScopedResource()
                try encryptedData.write(to: spotifyTokenURL)
                DiskAccessManager.stopAccessingSecurityScopedResource()
            }
        } catch {
            fatalError("Error writing JSON token: \(error.localizedDescription)")
        }
    }
    
    public static func deleteToken() {
        do {
            if let spotifyTokenURL = DiskAccessManager.spotifyTokenURL {
                DiskAccessManager.startAccessingSecurityScopedResource()
                try FileManager.default.removeItem(at: spotifyTokenURL)
                DiskAccessManager.stopAccessingSecurityScopedResource()
            }
        } catch let error {
            print("Error deleting JSON token: \(error.localizedDescription)")
        }
    }
}
