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
            let imageBlob = Expression<String?>("ZTHUMBNAILIMAGEDATA")

            let owner = Expression<String>("ZOWNER")
            let pk = Expression<String>("Z_PK")
            
            let contactsTable = Table("ZABCDRECORD")
            let phoneNumberTable = Table("ZABCDPHONENUMBER")
            
            let joinCondition = phoneNumberTable[owner] == contactsTable[pk]
            #warning("Is phone number ever null? How do we handle that case? Can we fall back to email?")
            var allContactsTable = phoneNumberTable
                .join(contactsTable, on: joinCondition)
                .select(firstName, lastName, phoneNumber, imageBlob)
            
            let allContactsRows = try database.prepare(allContactsTable)
            
            var allContactsRowsTuple = [(firstName: String?, lastName: String?, phoneNumber: String?, imageBlob: String?)]()
            // Iterate through the rows and access the selected values
            for contact in allContactsRows {
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                let phoneNumberValue = contact[phoneNumber]?.digits  //the digits is an extension declared in String.swift to strip any non-numeric digits
                let imageBlobValue = contact[imageBlob]
                
                //this code is used to prevent adding duplicate entries to allContactsRowsTuple
                if !allContactsRowsTuple.contains(where: { (fn: String?, ln: String?, pn: String?, ib: String?) in
                    firstNameValue == fn && lastNameValue == ln && phoneNumberValue == pn && imageBlobValue == ib
                }) {
                    allContactsRowsTuple.append((firstName: firstNameValue, lastName: lastNameValue, phoneNumber: phoneNumberValue, imageBlob: imageBlobValue))
                }
            }
            
            let firstNameData = allContactsRowsTuple.map { $0.firstName }
            let lastNameData = allContactsRowsTuple.map { $0.lastName }
            let phoneNumberData = allContactsRowsTuple.map { $0.phoneNumber }
            let imageBlobData = allContactsRowsTuple.map { $0.imageBlob }
            
            //contacts data frame is a data frame that holds all the contacts information retrieved from address book
            var contactsDataFrame = DataFrame()
            contactsDataFrame.append(column: Column(name: "firstName", contents: firstNameData))
            contactsDataFrame.append(column: Column(name: "lastName", contents: lastNameData))
            contactsDataFrame.append(column: Column(name: "phoneNumber", contents: phoneNumberData))
            contactsDataFrame.append(column: Column(name: "imageBlob", contents: imageBlobData))
            
            print(contactsDataFrame)
            
            //2
            
            return ""
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
