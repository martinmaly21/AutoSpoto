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
    
    func fetchGroupChats() {
        //TODO
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
            var contactsRowsTuple = [(firstName: String?, lastName: String?, contactInfo: String?, imageBlob: String?)]()
            // Iterate through the phone number rows and access the selected values
            for contact in phoneNumberContactsRows {
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                let phoneNumberValue = contact[phoneNumber]?.digits  //the digits is an extension declared in String.swift to strip any non-numeric digits
                let imageBlobValue = contact[imageBlob]
                
                //this code is used to prevent adding duplicate entries to contactsRowsTuple
                if !contactsRowsTuple.contains(where: { (fn: String?, ln: String?, ci: String?, ib: String?) in
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
                let emailValue = contact[email]
                let imageBlobValue = contact[imageBlob]
                
                //this code is used to prevent adding duplicate entries to emailContactsRowsTuple
                if !contactsRowsTuple.contains(where: { (fn: String?, ln: String?, ci: String?, ib: String?) in
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
            
            //sort chats by first name
            chatsWithAssociatedContactsAndPlaylistIDDataFrame.sort(on: "firstName", order: .ascending)
            
            //            Uncomment for debugging:
//            print("chatsWithAssociatedContactsAndPlaylistIDDataFrame: \(chatsWithAssociatedContactsAndPlaylistIDDataFrame.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
            
            return try chatsWithAssociatedContactsAndPlaylistIDDataFrame.jsonRepresentation()
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
    
    //retrieve a table that stores whether each chat
    //currently has a playlist associated with it
    private func retrievePlaylistsDataFrame() -> DataFrame {
        do {
            let chatID = Expression<Int?>("chatID")
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
