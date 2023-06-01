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
                readonly: true
            )
            
            // Execute the "attach" statements
            try database.execute("attach '\(chatDatabaseString)' as cdb")
            try database.execute("attach '\(addressBookDatabaseString)' as adb")
            
            // Execute the "CREATE TABLE IF NOT EXISTS" statement
            try database.execute("""
                CREATE TABLE IF NOT EXISTS playlists (
                    chat_ids INTEGER,
                    playlist_id TEXT,
                    last_updated TEXT
                )
            """)
        } catch let error {
            fatalError("Error with database (\(databaseString): \(error)")
        }
    }
    
    func fetchGroupChats() {
        //TODO
    }
    
    func fetchIndividualChats() -> String {
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
            var contactsDataFrame = DataFrame()
            contactsDataFrame.append(column: Column(name: "firstName", contents: contactsRowsTuple.map { $0.firstName }))
            contactsDataFrame.append(column: Column(name: "lastName", contents: contactsRowsTuple.map { $0.lastName }))
            contactsDataFrame.append(column: Column(name: "contactInfo", contents: contactsRowsTuple.map { $0.contactInfo }))
            contactsDataFrame.append(column: Column(name: "imageBlob", contents: contactsRowsTuple.map { $0.imageBlob }))
            
            print("contactsDataFrame: \(contactsDataFrame.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
            
            //2
            let guID = Expression<String?>("guid")
            let chatID = Expression<String?>("ROWID")
            
            let chatTable = Table("chat")
            
            let chatIDsQuery = chatTable
                .select(guID, chatID)
                .filter(!guID.like("%chat%"))
            
            let chatRows = try database.prepare(chatIDsQuery)
  
            var chatRowsTuple = [(contactInfo: String?, chatID: String?)]()
            for chat in chatRows {
                var contactInfo: String?
                
                if let guIDrow = chat[guID],
                    let range = guIDrow.range(of: "iMessage;-;") {
                    //this is the data without the 'iMessage;-;' prefix
                    let parsedData = String(guIDrow[range.upperBound...])
                    
                    if !parsedData.isValidEmail() {
                        contactInfo = parsedData.digits
                    }
                    
                    chatRowsTuple.append((contactInfo: contactInfo, chatID: "\(Int.random(in: 0...100000))")) //TODO: fix this
                }
            }
            
            //contacts data frame holds both the email and phone number contacts
            var chatsDataFrame = DataFrame()
            chatsDataFrame.append(column: Column(name: "contactInfo", contents: chatRowsTuple.map { $0.contactInfo }))
            chatsDataFrame.append(column: Column(name: "chatID", contents: chatRowsTuple.map { $0.chatID }))
            
            print("chatsDataFrame: \(chatsDataFrame.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
            
            let chatsWithAssociatedContactsDataFrame = chatsDataFrame
                .joined(contactsDataFrame, on: "contactInfo", kind: .left)
            
            print("chatsWithAssociatedContactsDataFrame: \(chatsWithAssociatedContactsDataFrame.description(options: .init(maximumLineWidth: 1000, maximumRowCount: 1000)))")
            
            return ""
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
