//
//  ExtractScript.swift
//  AutoSpoto
//
//  Created by Andrew Caravaggio on 2023-06-16.
//

import Foundation
import SQLite
import TabularData
class ExctractScript{
    
    func extractSpotifyTrackID(from url: String) -> String? {
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
    
    func FetchChats(){
        let chatDatabaseString = "\(NSHomeDirectory())/Library/Messages/chat.db"
        do{
            // MARK: Open a SQLite database connection
            let database = try Connection(
                chatDatabaseString,
                readonly: false
            )
        
            let messages = Table("message")
            let handleTable = Table("handle")
            let chatMessageJoin = Table("chat_message_join")
            let handleID = Expression<Int>("handle_id")
            let attributedBody = Expression<Data?>("attributedBody")
            let row  = Expression<Int>("ROWID")
            let date = Expression<Int>("date")
            let chatID = Expression<Int>("chat_id")
            let messageID = Expression<Int>("message_id")
            
            var outputTuple = [(AttributedBody: String?, chatid: Int, Date: Int)]()
            
            let chosenChat = 10
            for message in try database.prepare(messages.select(date, attributedBody, chatID).where(chatMessageJoin[chatID]==chosenChat).join(handleTable, on: handleTable[row]==messages[handleID]).join(chatMessageJoin, on: chatMessageJoin[messageID] == messages[row])){
                
                guard let attributedBodyData = message[attributedBody] else {
                    let _: String? = nil
                    return
                }
                
                
                let url = String(decoding: attributedBodyData, as: UTF8.self)
                print(url)
                let x = extractSpotifyTrackID(from: url)
                
                if (x != nil){
                    outputTuple.append((AttributedBody: x, chatid: message[chatID], Date: message[date]))
                    print(outputTuple)
                }
            }
            
//            let retrievedSongs: DataFrame = [
//                "Songs": outputTuple.map {$0.AttributedBody},
//                "chatId": outputTuple.map {$0.chatid},
//                "Date": outputTuple.map {$0.Date}
//            ]
//
//            print("data: \(retrievedSongs.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
//
            
        }catch let error {
            assertionFailure("Error with database: \(error.localizedDescription)")
        }
        
    }
}
