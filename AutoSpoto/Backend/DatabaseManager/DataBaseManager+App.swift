//
//  DataBaseManager+App.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-14.
//

import Foundation
import TabularData
import SQLite
import Contacts

extension DatabaseManager {
    func fetchGroupChats() async -> [Chat] {
        do {
            var contactsRowsTuple = [(chatID: Int, displayName: String, guID: String, messageID: String?)]()
            
            let chat_ids = Expression<Int?>("ROWID")
            let chat_name = Expression<String>("display_name")
            let guid = Expression<String?>("guid")
            let chatTable = Table("chat")
            let query = chatTable.select(chat_ids, chat_name, guid).filter(chat_name != "")
            
            for groupChat in try database.prepare(query){
                if let chatID = groupChat[chat_ids],
                   let guID = groupChat[guid],
                   let messageID = extractChatFromChatDB(input: guID) {
                    let name = groupChat[chat_name]
                    contactsRowsTuple.append((chatID: chatID, displayName: name, guID: guID, messageID: messageID))
                }
            }
            var groupChats: DataFrame = [
                "ChatId": contactsRowsTuple.map { $0.chatID },
                "ChatName": contactsRowsTuple.map { $0.displayName},
                "ContactInfo": contactsRowsTuple.map { $0.guID },
                "MessageID" : contactsRowsTuple.map { $0.messageID }
            ]
            //Here we are formatted the group chats that have a display name in the same format (array<string>) as the returned dataframe from fetchCahtsNoName
            groupChats = groupChats.grouped(by: "ChatId")
                .mapGroups({ slice in
                    var df = DataFrame()
                    
                    df["ChatId", Int.self] = Column(name: "ChatId", contents: [slice["ChatId"].first as! Int])
                    df["ChatName", [String].self] = Column(name: "ChatName", contents: [slice["ChatName"].compactMap { $0 as? String }])
                    df["ContactInfo", String.self] = Column(name: "ContactInfo", contents: [slice["ContactInfo"].first as! String])
                    df["MessageID", String.self] = Column(name: "MessageID", contents: [slice["MessageID"].first as! String])
                    
                    return df
                }).ungrouped()
            var chatsWithNoDisplayName  = await fetchGroupChatsNoNames()
            
            
            groupChats.append(chatsWithNoDisplayName)
          
            guard !groupChats.isEmpty else {
                //if there's no group chats, return an empty array early
                //this fixes crash when attempting to join on a data frame with no rows
                return []
            }
            
            let groupChatImages = getGroupImageFilePaths()
            
            let groupChatsWithImage = groupChats.joined(groupChatImages, on: "MessageID", kind: .left)
            var groupChatToUI = groupChatsWithImage.selecting(columnNames: "right.Base64Image", "left.ChatId", "left.ChatName", "MessageID")
            
            groupChatToUI.renameColumn("right.Base64Image", to: "image")
            groupChatToUI.renameColumn("left.ChatId" , to: "chatID")
            groupChatToUI.renameColumn("left.ChatName", to: "chatName")
            
            
            let trackedChatsDataFrame = retrieveTrackedChats()
            var finalGroupChatTable = groupChatToUI.joined(trackedChatsDataFrame, on: "chatID", kind: .left)
            
            finalGroupChatTable.renameColumn("left.image", to: "image")
            finalGroupChatTable.renameColumn("left.chatName" , to: "displayName")
            finalGroupChatTable.renameColumn("left.MessageID" , to: "MessageID")
            finalGroupChatTable.renameColumn("right.spotifyPlaylistID" , to: "playlistID")
            finalGroupChatTable.renameColumn("right.lastUpdated" , to: "lastUpdated")
            
            var renamedFinalGroupChatTable = finalGroupChatTable.selecting(columnNames: "image", "chatID", "chatName", "MessageID", "playlistID", "lastUpdated")
            
            //Now for the dataframe returned to the UI we change the output from an array of strings to a single string containing all of the array elements
            renamedFinalGroupChatTable["chatName"] = renamedFinalGroupChatTable["chatName", [String].self].map { value -> String in
                guard let value = value else
                {
                    return ""
                }
                
                let string = value.joined(separator: ", ")
                return string
            }
            // Create a new column that will hold the converted values
            
            renamedFinalGroupChatTable = renamedFinalGroupChatTable.grouped(by: "MessageID").mapGroups({slice in
                var df = DataFrame()
                df["ids", [Int].self] = Column(name: "ids", contents: [slice["chatID"].compactMap { $0 as? Int }])
                df["chatName", String.self] = Column(name: "chatName", contents: [slice["chatName"].first as! String])
                df["nameID", String.self] = Column(name: "nameID", contents: [slice["MessageID"].first as! String])
                df["imageBlob", String?.self] = Column(name: "imageBlob", contents: [slice["image"].first as? String])
                df["spotifyPlaylistID", String?.self] = Column(name: "spotifyPlaylistID", contents: [slice["playlistID"].first as? String])
                df["lastUpdated", Double?.self] = Column(name: "lastUpdated", contents: [slice["lastUpdated"].first as? Double])
                return df
            }).ungrouped()
            
            
            renamedFinalGroupChatTable.renameColumn("chatName", to: "name")
            let groupChatsJSON = try renamedFinalGroupChatTable.jsonRepresentation()
            
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([GroupChatCodable].self, from: groupChatsJSON)
            
            //now fetch chats for each
            let chats = tableData.map { Chat($0) }
            
            //now fetch track IDs for each chat
            await withTaskGroup(of: Void.self) { group in
                for chat in chats {
                    group.addTask {
                        let tracksWithNoMetadata = await self.fetchSpotifyTracksWithNoMetadata(for: chat.ids)
                        
                        chat.tracksPages = tracksWithNoMetadata.splitIntoChunks(of: chat.numberOfTrackMetadataPerFetch)
                    }
                }
                
                for await _ in group { }
                
                return
            }
            
            return chats
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
    
    func fetchGroupChatsNoNames() async -> DataFrame{
            
            do{
                
                var contactsRowsTuple = [(chat_identifier: String, contact_info: String?, chat_id: Int)]()
                
                let chatIdentifier = Expression<String>("chat_identifier")
                let ID = Expression<String?>("id")
                let chatID = Expression<Int>("chat_id")
                let displayName = Expression<String?>("display_name")
                let rowID = Expression<Int>("rowid")
                let handleID = Expression<Int?>("handle_id")
                
                let chatMessageJoin = Table("chat_message_join")
                let message = Table("message")
                let chatHandleJoin = Table("chat_handle_join")
                let handle = Table("handle")
                let chat = Table("chat")
                
                //Query that joins handle, chat, chat_handle_join and message
                let query = chat.select(chat[chatIdentifier], handle[ID], chatMessageJoin[chatID]).where(chatIdentifier.like("%chat%") && displayName == "").join(chatMessageJoin, on: chatMessageJoin[chatID]==chat[rowID]).join(chatHandleJoin, on: chatHandleJoin[chatID]==chat[rowID]).join(handle, on:handle[rowID]==chatHandleJoin[handleID]).group(chat[chatIdentifier], handle[ID])
                
                for groupChat in try database.prepare(query){
                    //Here we are removing the + in front of the phone number so that the value can be joined with the phone number from the fetchContacts()
                    var contact_info = groupChat[handle[ID]]
                    if ((contact_info?.hasPrefix("+")) != false){
                        contact_info?.removeFirst()
                    }
                    
                    contactsRowsTuple.append((chat_identifier:groupChat[chat[chatIdentifier]], contact_info: contact_info, chat_id: groupChat[chatMessageJoin[chatID]]))
                }
                
                let chatsDataFrame: DataFrame = [
                    "MessageID": contactsRowsTuple.map { $0.chat_identifier },
                    "contactInfo": contactsRowsTuple.map { $0.contact_info },
                    "chatID": contactsRowsTuple.map { $0.chat_id },
                    "imageBlob": contactsRowsTuple.map {_ in nil}
                ]
                
                var contactDF = await fetchContacts()
                
                var chatsWithAssociatedContactsDataFrame = chatsDataFrame
                    .joined(contactDF, on: "contactInfo", kind: .left)
                
                chatsWithAssociatedContactsDataFrame.renameColumn("left.chatID", to: "chatID")
                chatsWithAssociatedContactsDataFrame.renameColumn("right.firstName", to: "firstName")
                chatsWithAssociatedContactsDataFrame.renameColumn("right.lastName", to: "lastName")
                chatsWithAssociatedContactsDataFrame.renameColumn("right.imageBlob", to: "imageBlob")
                
                //here we are checking if where there is a first name, last name or just a phone number for the contact
                for (index, row) in chatsWithAssociatedContactsDataFrame.rows.enumerated(){
                    
                    var firstNameNil = (row[3]==nil)
                    var lastNameNil = (row[4]==nil)
                    
                   //If a first name exists do nothing
                    if (!firstNameNil){
                        continue
                    }
                    //assign the last name to the display name if there is no first name but there is a last name
                    else if(!lastNameNil){
                        chatsWithAssociatedContactsDataFrame.rows[index]["firstName"] = row[4]
                    }
                    //if no first and last name assign the phone number as the display name
                    else{
                        chatsWithAssociatedContactsDataFrame.rows[index]["firstName"] = row[1]
                    }
                }
                
                
                
                var chatsWithDisplayNames = chatsWithAssociatedContactsDataFrame.selecting(columnNames: "chatID", "firstName","MessageID","contactInfo")
                
                //Here we are grouping the chat names by the chat ID. This way contacts beloning to a group chat that doesnt have a name can be aggregated
                chatsWithDisplayNames = chatsWithDisplayNames.grouped(by: "chatID")
                    .mapGroups({ slice in
                        var df = DataFrame()
                        
                        df["chatID", Int.self] = Column(name: "chatID", contents: [slice["chatID"].first as! Int])
                        df["firstName", [String].self] = Column(name: "firstName", contents: [slice["firstName"].compactMap { $0 as? String }])
                        df["contactInfo", String.self] = Column(name: "contactInfo", contents: [slice["contactInfo"].first as! String])
                        df["MessageID", String.self] = Column(name: "MessageID", contents: [slice["MessageID"].first as! String])
                        
                        return df
                    }).ungrouped()

                chatsWithDisplayNames.renameColumn("firstName", to: "ChatName")
                chatsWithDisplayNames.renameColumn("contactInfo", to: "ContactInfo")
                chatsWithDisplayNames.renameColumn("chatID", to: "ChatId")
                return chatsWithDisplayNames
                
            }catch let error{
                fatalError("Error: \(error)")
            }
        }
    
    
    
    func fetchContacts() async -> DataFrame{
        do{
            
            let contactStore = CNContactStore()
            
            let keysToFetch: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactMiddleNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor
            ]
            
            let result = try? await CNContactStore().requestAccess(for: .contacts)
            
            var contactsRowsTuple = [(firstName: String?, lastName: String?, contactInfo: String, imageBlob: String?)]()
            
            if result ?? false {
                //user has given AutoSpoto contact permissions
                var allContainers: [CNContainer] = []
                do {
                    allContainers = try contactStore.containers(matching: nil)
                } catch let error {
                    print("Error fetching containers: \(error)")
                }
                
                var results: [CNContact] = []
                
                // Iterate all containers and append their contacts to our results array
                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    do {
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                        results.append(contentsOf: containerResults)
                    } catch {
                        print("Error fetching results for container")
                    }
                }
                
                //contacts data frame holds both the email and phone number contacts
                for result in results {
                    let firstName = result.givenName + result.middleName
                    let lastName = result.familyName
                    let image = result.thumbnailImageData
                    
                    //we want to appenda  separate row in the DataFrame for each variation of the contact
                    //i.e. there should be a separate row for each contact #, each email, even if within the same contact
                    for result in result.phoneNumbers {
                        contactsRowsTuple.append((firstName: firstName, lastName: lastName, contactInfo: result.value.stringValue.digits, imageBlob: image?.base64EncodedString()))
                    }
                    
                    for result in result.emailAddresses {
                        contactsRowsTuple.append((firstName: firstName, lastName: lastName, contactInfo: String(result.value), imageBlob: image?.base64EncodedString()))
                    }
                }
                
            }
            var contactRows: [ContactRow] = []
            
            // Iterate through the original array
            for row in contactsRowsTuple {
                // Check if contactInfo already exists in contactStruct
                let contactInfo = row.contactInfo
                let contactInfoExists = contactRows.contains { $0.contactInfo == contactInfo }
                
                // Add the row only if contactInfo doesn't exist in contactStruct
                if !contactInfoExists {
                    let customRow = ContactRow(
                        firstName: row.firstName,
                        lastName: row.lastName,
                        contactInfo: row.contactInfo,
                        imageBlob: row.imageBlob
                    )
                    contactRows.append(customRow)
                }
            }
            
            contactRows = contactRows.unique
            
            let contactsDataFrame: DataFrame = [
                "firstName": contactRows.map { $0.firstName }.isEmpty ? [""] : contactRows.map { $0.firstName },
                "lastName": contactRows.map { $0.lastName }.isEmpty ? [""] : contactRows.map { $0.lastName },
                "contactInfo": contactRows.map { $0.contactInfo }.isEmpty ? [""] : contactRows.map { $0.contactInfo },
                "imageBlob": contactRows.map { $0.imageBlob }.isEmpty ? [""] : contactRows.map { $0.imageBlob }
            ]
            
            return contactsDataFrame
        }
        catch let error{
            fatalError("error: \(error)")
        }
    }
    func fetchIndividualChats() async -> [Chat] {
        do {
            
            let contactsDataFrame = await fetchContacts()
            //2
            let guID = Expression<String?>("guid")
            let chatID = Expression<Int>("ROWID")
            
            let chatTable = Table("chat")
            
            let chatIDsQuery = chatTable
                .select(guID, chatID)
                .filter(!guID.like("%chat%"))
            
            let chatRows = try database.prepare(chatIDsQuery)
            
            var chatRowsTuple = [(contactInfo: String?, chatID: Int)]()
            for chat in chatRows {
                var contactInfo: String?
                
                if let guIDrow = chat[guID],
                   let range = guIDrow.range(of: ";-;") {
                    //this is the data without the 'iMessage;-;' prefix
                    let parsedData = String(guIDrow[range.upperBound...])
                    
                    if !parsedData.isValidEmail() {
                        contactInfo = parsedData.digits
                    }
                    
                    chatRowsTuple.append((contactInfo: contactInfo, chatID: chat[chatID]))
                }
            }
            //contacts data frame holds both the email and phone number contacts
            let chatsDataFrame: DataFrame = [
                "contactInfo": chatRowsTuple.map { $0.contactInfo },
                "chatID": chatRowsTuple.map { $0.chatID }
            ]
            guard !chatsDataFrame.isEmpty else {
                //if there's no individual chats, return an empty array early
                //this fixes crash when attempting to join on a data frame with no rows
                return []
            }
            
            var chatsWithAssociatedContactsDataFrame = chatsDataFrame
                .joined(contactsDataFrame, on: "contactInfo", kind: .left)
            
            //rename columns back to previous pre-join values
            chatsWithAssociatedContactsDataFrame.renameColumn("left.chatID", to: "chatID")
            chatsWithAssociatedContactsDataFrame.renameColumn("right.firstName", to: "firstName")
            chatsWithAssociatedContactsDataFrame.renameColumn("right.lastName", to: "lastName")
            chatsWithAssociatedContactsDataFrame.renameColumn("right.imageBlob", to: "imageBlob")
            
            //associate 'spotifyPlaylistID' and 'lastUpdated' (if they exist), with the chat
            let trackedChatsDataFrame = retrieveTrackedChats()
            var chatsWithAssociatedContactsAndPlaylistIDDataFrame = chatsWithAssociatedContactsDataFrame
                .joined(trackedChatsDataFrame, on: "chatID", kind: .left)
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
                    
                    df["ids", [Int].self] = Column(name: "ids", contents: [slice["chatID"].compactMap { $0 as? Int }])
                    df["contactInfo", String.self] = Column(name: "contactInfo", contents: [slice["contactInfo"].first as! String])
                    df["firstName", String?.self] = Column(name: "firstName", contents: [slice["firstName"].first as? String])
                    df["lastName", String?.self] = Column(name: "lastName", contents: [slice["lastName"].first as? String])
                    df["imageBlob", String?.self] = Column(name: "imageBlob", contents: [slice["imageBlob"].first as? String])
                    df["spotifyPlaylistID", String?.self] = Column(name: "spotifyPlaylistID", contents: [slice["spotifyPlaylistID"].first as? String])
                    df["lastUpdated", Double?.self] = Column(name: "lastUpdated", contents: [slice["lastUpdated"].first as? Double])
                    
                    return df
                })
                .ungrouped()
            
            let individualChatsJSON = try chatsWithAssociatedContactsAndPlaylistIDDataFrame.jsonRepresentation()
            let decoder = JSONDecoder()
            let tableData = try decoder.decode([IndividualChatCodable].self, from: individualChatsJSON)
            
            //now fetch chats for each
            let chats = tableData.map { Chat($0) }
            
            //now fetch track IDs for each chat
            await withTaskGroup(of: Void.self) { group in
                for chat in chats {
                    group.addTask {
                        let tracksWithNoMetadata = await self.fetchSpotifyTracksWithNoMetadata(for: chat.ids)
                        
                        chat.tracksPages = tracksWithNoMetadata.splitIntoChunks(of: chat.numberOfTrackMetadataPerFetch)
                    }
                }
                
                for await _ in group { }
                
                return
            }
            
            
            return chats
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
