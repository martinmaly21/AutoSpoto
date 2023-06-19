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
    
    
    func formatDate(from posixDate: Int) -> String{
        
        let inputDateInSeconds = Double(posixDate) / 1_000_000_000.0

        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)

        let referenceDateTimeIntervalSince1970 = referenceDate.timeIntervalSince1970

        let outputTimeInterval = referenceDateTimeIntervalSince1970 + inputDateInSeconds

        let outputDate = Date(timeIntervalSince1970: outputTimeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let outputString = dateFormatter.string(from: outputDate)
        
        return outputString
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
            let payloadData = Expression<Data?>("attributedBody")
            let row  = Expression<Int>("ROWID")
            let date = Expression<Int>("date")
            let chatID = Expression<Int>("chat_id")
            let messageID = Expression<Int>("message_id")
            
            var outputTuple = [(AttributedBody: String?, chatid: Int, Date: String)]()
            
            let chosenChat = 10
            for message in try database.prepare(messages.select(date, payloadData, chatID).filter(payloadData != nil).where(chatMessageJoin[chatID]==chosenChat).join(.leftOuter, handleTable, on: handleTable[row]==messages[handleID]).join(.leftOuter, chatMessageJoin, on: chatMessageJoin[messageID] == messages[row])){
                
                guard let attributedBodyData = message[payloadData] else {
                    return
                }

                let url = String(decoding: attributedBodyData, as: UTF8.self)
                let x = extractSpotifyTrackID(from: url)
//
                if (x != nil){
                    
                    let outputString = formatDate(from: message[date])
                    outputTuple.append((AttributedBody: x, chatid: message[chatID], Date: outputString))
                }
            }
            //print(outputTuple)
            let retrievedSongs: DataFrame = [
                "Songs": outputTuple.map {$0.AttributedBody},
                "chatId": outputTuple.map {$0.chatid},
                "Date": outputTuple.map {$0.Date}
            ]
//
//            print("data: \(retrievedSongs.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
//
            
        }catch let error {
            assertionFailure("Error with database: \(error.localizedDescription)")
        }
        
    }
}
