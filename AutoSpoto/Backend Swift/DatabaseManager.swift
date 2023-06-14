//
//  DatabaseManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-05-30.
//

import Foundation
import SQLite
import TabularData

class DatabaseManager {
    public static var shared: DatabaseManager!
    
    private let databaseString: String
    private let database: Connection
    
    init(databaseString: String, addressBookID: String) {
        self.databaseString = databaseString
        
        let homeDirectory = "\(NSHomeDirectory())"
        let chatDatabaseString = "\(homeDirectory)/Library/Messages/chat.db"
        let addressBookDatabaseString = "\(homeDirectory)/Library/Application Support/AddressBook/Sources/\(addressBookID)/AddressBook-v22.abcddb"
        
        do {
            // Open a SQLite database connection
            self.database = try Connection(
                databaseString,
                readonly: false
            )
            
            // Execute the "attach" statements
            try database.execute("attach '\(chatDatabaseString)' as cdb")
            try database.execute("attach '\(addressBookDatabaseString)' as adb")
            
            // Execute the "CREATE TABLE IF NOT EXISTS" statement
            try database.execute("""
                CREATE TABLE IF NOT EXISTS CREATED_PLAYLISTS (
                    chatID INTEGER,
                    spotifyPlaylistID TEXT,
                    lastUpdated TEXT
                )
            """)
        } catch let error {
            fatalError("Error with database (\(databaseString): \(error)")
        }
    }
    func extractChatFromPath(input: String) -> String? {
        guard let rangeStart = input.range(of: "chat"),
              let rangeEnd = input.range(of: "%", range: rangeStart.upperBound..<input.endIndex) else {
            return nil
        }
        
        let startIndex = rangeStart.upperBound
        let endIndex = rangeEnd.lowerBound
        let extractedText = input[startIndex..<endIndex]
        
        return String(extractedText)
    }
    
    func extractChatFromChatDB(input: String) -> String? {
        guard let range = input.range(of: "chat") else {
            return nil
        }
        
        let startIndex = range.upperBound
        let extractedText = input[startIndex...]
        
        return String(extractedText)
    }
    
    func imageToBase64(filePath: String) -> String? {
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            let base64String = imageData.base64EncodedString()
            return base64String
        } catch {
            print("Error converting image to Base64: \(error)")
            return nil
        }
    }
    
    func getGroupImageFilePaths() -> DataFrame {
        
        do{
            let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
            let directoryURL = homeDirectory.appendingPathComponent("Library/Intents/Images")
            var directories = [(DirPath:(String)?, ChatId: (String)?, image:(String)?)]()
            
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
                for fileURL in contents {
                    let directory = fileURL.path
                    if directory.hasSuffix("GroupPhotoImage.png"){
                        directories.append((DirPath:directory, ChatId:extractChatFromPath(input: directory), image:imageToBase64(filePath: directory) ))
                    }
                }
            } catch {
                print("Error reading directory: \(error)")
            }
            let directoryTB: DataFrame = [
                "directoryPath": directories.map {$0.DirPath},
                "MessageID": directories.map {$0.ChatId},
                "Base64Image": directories.map {$0.image}
            ]
            
            return directoryTB
        }catch let error{
            fatalError("Error: \(error)")
        }
    }
    
    func fetchGroupChats() -> Data {
        do {
            
            var contactsRowsTuple = [(chatID: Int?, displayName: String?, unique_id: String?, message_id: String?)]()
            
            
            let chat_ids = Expression<Int?>("ROWID")
            let chat_name = Expression<String?>("display_name")
            let guid = Expression<String?>("guid")
            let chatTable = Table("chat")
            
            let query = chatTable.select(chat_ids, chat_name, guid).filter(chat_name != "")
            
            for groupChat in try database.prepare(query){
                let chatId = groupChat[chat_ids]
                let name = groupChat[chat_name]
                let uid = groupChat[guid]
                let MessageID = extractChatFromChatDB(input: uid!)
                contactsRowsTuple.append((chatID: chatId, displayName:name, unique_id: uid, message_id:MessageID))
            }
            let groupChats: DataFrame = [
                "ChatId": contactsRowsTuple.map { $0.chatID },
                "ChatName": contactsRowsTuple.map { $0.displayName},
                "ContactInfo": contactsRowsTuple.map { $0.unique_id},
                "MessageID" : contactsRowsTuple.map { $0.message_id}
            ]
            
            let groupChatImages = getGroupImageFilePaths()
            
            var groupChatsWithImage = groupChatImages.joined(groupChats, on: "MessageID", kind: .left)
            var groupChatToUI = groupChatsWithImage.selecting(columnNames: "left.Base64Image", "right.ChatId", "right.ChatName")
            
            groupChatToUI.renameColumn("left.Base64Image", to: "image")
            groupChatToUI.renameColumn("right.ChatId" , to: "chatID")
            groupChatToUI.renameColumn("right.ChatName", to: "chatName")
            let playlistDataFrame = retrievePlaylistsDataFrame()
            
            var finalGroupChatTable = groupChatToUI.joined(playlistDataFrame, on: "chatID", kind: .left)
            
            finalGroupChatTable.renameColumn("left.image", to: "image")
            finalGroupChatTable.renameColumn("left.chatName" , to: "chatName")
            finalGroupChatTable.renameColumn("right.spotifyPlaylistID" , to: "playlistID")
            
            
            var renamedFinalGroupChatTable = finalGroupChatTable.selecting(columnNames: "image", "chatID", "chatName", "playlistID")
            
            
            print("data: \(renamedFinalGroupChatTable.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
            return try groupChats.jsonRepresentation()
            
        }catch let error{
            fatalError("Error: \(error)")
        }
    }
    
    func fetchIndividualChats() -> Data {
        do {
            //1
            let firstName = Expression<String?>("ZFIRSTNAME")
            let lastName = Expression<String?>("ZLASTNAME")
            let phoneNumber = Expression<String?>("ZFULLNUMBER")
            let email = Expression<String?>("ZADDRESS")
            let imageBlob = Expression<String?>("ZTHUMBNAILIMAGEDATA")
            
            let owner = Expression<String>("ZOWNER")
            let pk = Expression<String>("Z_PK")
            
            let contactsTable = Table("ZABCDRECORD")
            let phoneNumberTable = Table("ZABCDPHONENUMBER")
            let emailTable = Table("ZABCDEMAILADDRESS")
            
            //MARK: - Phone number contact extraction
            let phoneNumberJoinCondition = phoneNumberTable[owner] == contactsTable[pk]
            let allPhoneNumberContactsTable = phoneNumberTable
                .join(contactsTable, on: phoneNumberJoinCondition)
                .select(firstName, lastName, phoneNumber, imageBlob)
            
            let phoneNumberContactsRows = try database.prepare(allPhoneNumberContactsTable)
            
            //Note: 'contactInfo' will be either an email or a string
            var contactsRowsTuple = [(firstName: String?, lastName: String?, contactInfo: String, imageBlob: String?)]()
            // Iterate through the phone number rows and access the selected values
            for contact in phoneNumberContactsRows {
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                
                let imageBlobValue = contact[imageBlob]
                
                //the digits is an extension declared in String.swift to strip any non-numeric digits from phone number
                if let phoneNumberValue = contact[phoneNumber]?.digits,
                   //this code is used to prevent adding duplicate entries to contactsRowsTuple
                   !contactsRowsTuple.contains(where: { (fn: String?, ln: String?, ci: String?, ib: String?) in
                       firstNameValue == fn && lastNameValue == ln && phoneNumberValue == ci && imageBlobValue == ib
                   }) {
                    contactsRowsTuple.append((firstName: firstNameValue, lastName: lastNameValue, contactInfo: phoneNumberValue, imageBlob: imageBlobValue))
                }
            }
            
            //MARK: - Email contact extraction
            let emailJoinCondition = emailTable[owner] == contactsTable[pk]
            let allEmailContactsTable = emailTable
                .join(contactsTable, on: emailJoinCondition)
                .select(firstName, lastName, email, imageBlob)
            
            let emailContactsRows = try database.prepare(allEmailContactsTable)
            
            // Iterate through the email rows and access the selected values
            for contact in emailContactsRows {
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                
                let imageBlobValue = contact[imageBlob]
                
                //this code is used to prevent adding duplicate entries to emailContactsRowsTuple
                if let emailValue = contact[email],
                   !contactsRowsTuple.contains(where: { (fn: String?, ln: String?, ci: String?, ib: String?) in
                       firstNameValue == fn && lastNameValue == ln && emailValue == ci && imageBlobValue == ib
                   }) {
                    contactsRowsTuple.append((firstName: firstNameValue, lastName: lastNameValue, contactInfo: emailValue, imageBlob: imageBlobValue))
                }
            }
            
            //contacts data frame holds both the email and phone number contacts
            let contactsDataFrame: DataFrame = [
                "firstName": contactsRowsTuple.map { $0.firstName },
                "lastName": contactsRowsTuple.map { $0.lastName },
                "contactInfo": contactsRowsTuple.map { $0.contactInfo },
                "imageBlob": contactsRowsTuple.map { $0.imageBlob }
            ]
            
            //2
            let guID = Expression<String?>("guid")
            let chatID = Expression<String?>("ROWID")
            
            let chatTable = Table("chat")
            
            let chatIDsQuery = chatTable
                .select(guID, chatID)
                .filter(!guID.like("%chat%"))
            
            let chatRows = try database.prepare(chatIDsQuery)
            
            var chatRowsTuple = [(contactInfo: String?, chatID: Int?)]()
            for chat in chatRows {
                var contactInfo: String?
                
                if let guIDrow = chat[guID],
                   let range = guIDrow.range(of: "iMessage;-;") {
                    //this is the data without the 'iMessage;-;' prefix
                    let parsedData = String(guIDrow[range.upperBound...])
                    
                    if !parsedData.isValidEmail() {
                        contactInfo = parsedData.digits
                    }
                    
                    chatRowsTuple.append((contactInfo: contactInfo, chatID: Int.random(in: 0...100000))) //TODO: fix this
                }
            }
            
            //contacts data frame holds both the email and phone number contacts
            let chatsDataFrame: DataFrame = [
                "contactInfo": chatRowsTuple.map { $0.contactInfo },
                "chatID": chatRowsTuple.map { $0.chatID }
            ]
            
            var chatsWithAssociatedContactsDataFrame = chatsDataFrame
                .joined(contactsDataFrame, on: "contactInfo", kind: .left)
            
            //rename columns back to previous pre-join values
            chatsWithAssociatedContactsDataFrame.renameColumn("left.chatID", to: "chatID")
            chatsWithAssociatedContactsDataFrame.renameColumn("right.firstName", to: "firstName")
            chatsWithAssociatedContactsDataFrame.renameColumn("right.lastName", to: "lastName")
            chatsWithAssociatedContactsDataFrame.renameColumn("right.imageBlob", to: "imageBlob")
            
            //associate 'spotifyPlaylistID' and 'lastUpdated' (if they exist), with the chat
            let playlistsDataFrame = retrievePlaylistsDataFrame()
            var chatsWithAssociatedContactsAndPlaylistIDDataFrame = chatsWithAssociatedContactsDataFrame
                .joined(playlistsDataFrame, on: "chatID", kind: .left)
            
            //rename columns (this makes the JSON easier to read)
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.renameColumn("left.contactInfo", to: "contactInfo")
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.renameColumn("left.firstName", to: "firstName")
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.renameColumn("left.lastName", to: "lastName")
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.renameColumn("left.imageBlob", to: "imageBlob")
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.renameColumn("right.spotifyPlaylistID", to: "spotifyPlaylistID")
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.renameColumn("right.lastUpdated", to: "lastUpdated")
            
            //This method is responsible for grouping together chatID's for the same
            //phone number. This can sometimes happen if a user has a chat with
            //a certain phone number over iMessage AND text message
            chatsWithAssociatedContactsAndPlaylistIDDataFrame = chatsWithAssociatedContactsAndPlaylistIDDataFrame
                .grouped(by: "contactInfo")
                .mapGroups({ slice in
                    var df = DataFrame()
                    
                    df["chatIDs", [Int].self] = Column(name: "chatIDs", contents: [slice["chatID"].compactMap { $0 as? Int }])
                    df["contactInfo", String.self] = Column(name: "contactInfo", contents: [slice["contactInfo"].first as! String])
                    df["firstName", String?.self] = Column(name: "firstName", contents: [slice["firstName"].first as? String])
                    df["lastName", String?.self] = Column(name: "lastName", contents: [slice["lastName"].first as? String])
                    df["imageBlob", String?.self] = Column(name: "imageBlob", contents: [slice["imageBlob"].first as? String])
                    df["spotifyPlaylistID", String?.self] = Column(name: "spotifyPlaylistID", contents: [slice["spotifyPlaylistID"].first as? String])
                    df["lastUpdated", String?.self] = Column(name: "lastUpdated", contents: [slice["lastUpdated"].first as? String])
                    
                    return df
                })
                .ungrouped()
            
            //sort chats by first name
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.sort(
                on: "firstName",
                String?.self,
                by: { lhs, rhs in
                    guard let lhs = lhs else {
                        return false
                    }
                    guard let rhs = rhs else {
                        return true
                    }
                    
                    return lhs.localizedCaseInsensitiveCompare(rhs) == ComparisonResult.orderedAscending
                }
            )
            
            //                can be useful for debugging:
            //                print("grouped: \(chatsWithAssociatedContactsAndPlaylistIDDataFrame.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
            
            return try chatsWithAssociatedContactsAndPlaylistIDDataFrame.jsonRepresentation()
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
    
    //retrieve a table that stores whether each chat
    //currently has a playlist associated with it
    private func retrievePlaylistsDataFrame() -> DataFrame {
        do {
            let chatID = Expression<Int>("chatID")
            let spotifyPlaylistID = Expression<String?>("spotifyPlaylistID")
            let lastUpdated = Expression<String?>("lastUpdated")
            
            let playlistsTable = Table("CREATED_PLAYLISTS")
            let allPlaylistsTable = playlistsTable.select(chatID, spotifyPlaylistID, lastUpdated)
            let playlistsRows = try database.prepare(allPlaylistsTable)
            
            var playlistsRowsTuple = [(chatID: Int?, spotifyPlaylistID: String?, lastUpdated: String?)]()
            for row in playlistsRows {
                playlistsRowsTuple.append((chatID: row[chatID], spotifyPlaylistID: row[spotifyPlaylistID], lastUpdated: row[lastUpdated]))
            }
            
            let playlistsDataFrame: DataFrame = [
                "chatID": playlistsRowsTuple.map { $0.chatID },
                "spotifyPlaylistID": playlistsRowsTuple.map { $0.spotifyPlaylistID },
                "lastUpdated": playlistsRowsTuple.map { $0.lastUpdated },
            ]
            
            return playlistsDataFrame
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
    
}
