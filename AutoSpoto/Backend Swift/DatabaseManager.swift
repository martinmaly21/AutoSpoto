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
            
            var contactsRowsTuple = [(firstName: String?, lastName: String?, phoneNumber: String?, email: String?, imageBlob: String?)]()
            // Iterate through the phone number rows and access the selected values
            for contact in phoneNumberContactsRows {
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                let phoneNumberValue = contact[phoneNumber]?.digits  //the digits is an extension declared in String.swift to strip any non-numeric digits
                let imageBlobValue = contact[imageBlob]
                
                //this code is used to prevent adding duplicate entries to contactsRowsTuple
                if !contactsRowsTuple.contains(where: { (fn: String?, ln: String?, pn: String?, e: String?, ib: String?) in
                    firstNameValue == fn && lastNameValue == ln && phoneNumberValue == pn && imageBlobValue == ib
                }) {
                    contactsRowsTuple.append((firstName: firstNameValue, lastName: lastNameValue, phoneNumber: phoneNumberValue, email: nil, imageBlob: imageBlobValue))
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
                if !contactsRowsTuple.contains(where: { (fn: String?, ln: String?, phoneNumber: String?, email: String?, ib: String?) in
                    firstNameValue == fn && lastNameValue == ln && emailValue == email && imageBlobValue == ib
                }) {
                    contactsRowsTuple.append((firstName: firstNameValue, lastName: lastNameValue, phoneNumber: nil, email: emailValue, imageBlob: imageBlobValue))
                }
            }
            
            //MARK: combining the data from contactsRowsTuple into a tuple
            let firstNameData = contactsRowsTuple.map { $0.firstName }
            let lastNameData = contactsRowsTuple.map { $0.lastName }
            let phoneNumberData = contactsRowsTuple.map { $0.phoneNumber }
            let emailData = contactsRowsTuple.map { $0.email }
            let imageBlobData = contactsRowsTuple.map { $0.imageBlob }
            
            //contacts data frame holds both the email and phone number contacts
            var contactsDataFrame = DataFrame()
            contactsDataFrame.append(column: Column(name: "firstName", contents: firstNameData))
            contactsDataFrame.append(column: Column(name: "lastName", contents: lastNameData))
            contactsDataFrame.append(column: Column(name: "phoneNumber", contents: phoneNumberData))
            contactsDataFrame.append(column: Column(name: "email", contents: emailData))
            contactsDataFrame.append(column: Column(name: "imageBlob", contents: imageBlobData))
            
            //2
            let guID = Expression<String?>("guid")
            let chatIDs = Expression<String?>("ROWID")
            
            let table = Table("chat")
            
            let chatIDsQuery = table
                .select(guID, chatIDs)
                .filter(!guID.like("%chat%"))
            
            let p = try database.prepare(chatIDsQuery)
  
            var allChatRowsTuple = [(email: String?, phoneNumber: String?, chatID: String?)]()
            for row in p {
                
                if let guIDrow = row[guID],
                    let range = guIDrow.range(of: "iMessage;-;") {
                    //this is the data without the 'iMessage;-;' prefix
                    let parsedData = String(guIDrow[range.upperBound...])
                    
                    if parsedData.isValidEmail() {
                        //chat is with email
                        print("Test:\(parsedData)")
                    } else {
                        //how i want to do it:
                        //if contact exists, associate it, otherwise just attach phoneNumber
                        //
                        
                        //logic
                        
                        //check if regEx is email
                        //if not, strip non-numeric and compare characters
                        //else, attach value after 'iMessage;-;' to table
                        //chat is with phone number
                        //phone number
                    }
                }
            }
            
            return ""
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
