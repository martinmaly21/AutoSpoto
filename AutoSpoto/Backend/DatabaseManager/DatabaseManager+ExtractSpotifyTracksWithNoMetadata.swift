//
//  DatabaseManager+ExtractSpotifyTracksWithNoMetadata.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation
import SQLite

//MARK: - this extension is for extracting the Spotify Track id's from a given chat
extension DatabaseManager {
    public func fetchSpotifyTracksWithNoMetadata(
        for chatIDs: [Int]
    ) async -> [Track] {
        var tracks: [Track] = []
        
        chatIDs.forEach { selectedChatIDs in
            tracks += fetchSongsFromChats(from: selectedChatIDs)
        }
        
        //remove duplicates
        tracks = tracks.unique
        
        //sort tracks
        tracks.sort()
        
        return tracks
    }
    
    private func extractSpotifyTrackID(from url: String) -> String? {
        let pattern = #"https:\/\/open\.spotify\.com\/track\/(?![a-zA-Z0-9]{19}WHt)[a-zA-Z0-9]{22}"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let range = NSRange(location: 0, length: url.utf16.count)
        if let match = regex.firstMatch(in: url, options: [], range: range) {
            let trackIDRange = match.range(at: 0)
            if let trackIDRange = Range(trackIDRange, in: url) {
                return String(url[trackIDRange])
            }
        }

        return nil
    }
    
    
    private func formatDate(from posixDate: Int) -> Date {
        let inputDateInSeconds = Double(posixDate) / 1_000_000_000.0
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        let referenceDateTimeIntervalSince1970 = referenceDate.timeIntervalSince1970
        let outputTimeInterval = referenceDateTimeIntervalSince1970 + inputDateInSeconds
        let outputDate = Date(timeIntervalSince1970: outputTimeInterval)
        
        return outputDate
    }
    
    private func removeSpotifyPrefix(from url: String) -> String {
        let prefix = "https://open.spotify.com/track/"
        if url.hasPrefix(prefix) {
            let startIndex = url.index(url.startIndex, offsetBy: prefix.count)
            return String(url[startIndex...])
        }
        return url
    }
    
    private func fetchSongsFromChats(from selectedChatIDs: Int) ->[Track]{
        do {
            let messages = Table("message")
            let handleTable = Table("handle")
            let chatMessageJoin = Table("chat_message_join")
            let handleID = Expression<Int>("handle_id")
            let payloadData = Expression<Data?>("attributedBody")
            let row  = Expression<Int>("ROWID")
            let date = Expression<Int>("date")
            let chatID = Expression<Int>("chat_id")
            let messageID = Expression<Int>("message_id")
            
            var tracks: [Track] = []
            let chosenChat = selectedChatIDs
            for message in try database
                .prepare(messages.select(date, payloadData, chatID)
                    .filter(payloadData != nil)
                    .where(chatMessageJoin[chatID]==chosenChat)
                    .join(.leftOuter, handleTable, on: handleTable[row]==messages[handleID])
                    .join(.leftOuter, chatMessageJoin, on: chatMessageJoin[messageID] == messages[row])) {
                
                guard let attributedBodyData = message[payloadData] else {
                    continue
                }
                
                let decodedPayload = String(decoding: attributedBodyData, as: UTF8.self)
                
                if let url = extractSpotifyTrackID(from: decodedPayload){
                    let track = removeSpotifyPrefix(from: url)
                    let formattedDate = formatDate(from: message[date])
                    tracks.append(Track(spotifyID: track, timeStamp: formattedDate))
                }
            }
            
            return tracks
        } catch let error {
            fatalError("Error fetching songs from chats: \(error.localizedDescription)")
        }
    }
}