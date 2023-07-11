//
//  SpotifyTokenManager.swift
//  AutoSpoto
//
//  Created by Andrew Caravaggio on 2023-07-07.
//

import Foundation


class SpotifyTokenManager{

    static func writeJsonTokenFile(spotifyToken: SpotifyToken){
        
        
        let jsonToken = JsonToken.init(spotifyToken: spotifyToken)
        let jsonEncoder = JSONEncoder()
        
        
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            
            do{
                let jsonData = try jsonEncoder.encode(jsonToken)
                try jsonData.write(to: directoryURL)
            } catch {
                #warning("Handle error")
            }
        }
    }
    
    static func readJsonTokenFile()->JsonToken?{
        
        let decoder = JSONDecoder()
        
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            
            do{
                let data = try Data(contentsOf: directoryURL)
                let jsonToken = try decoder.decode(JsonToken.self, from: data)
                return jsonToken
            } catch let error {
                #warning("Handle error")
            }
        }
        return nil
    }
    
    static func deleteJSONTokenFile(){
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first{
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/spotifyToken.json")
            do {
                try FileManager.default.removeItem(at: directoryURL)
            } catch let error {
                #warning("Handle error")
            }
        }
    }
    
    static func jsonTokenExist()->Bool{
        return readJsonTokenFile(
        ) != nil
    }
   
    static func accessTokenHasExpired(date: Date) -> Bool {
        return date < Date()
    }
    
    public static var authenticationTokenExists: Bool {
        return self.readJsonTokenFile()
        != nil
    }
    
}
