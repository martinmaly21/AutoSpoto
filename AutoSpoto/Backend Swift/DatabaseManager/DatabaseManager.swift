//
//  DatabaseManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-05-30.
//

import Foundation
import SQLite
import TabularData
import Contacts

class DatabaseManager {
    public static var shared: DatabaseManager!
    
    internal let database: Connection
    
    init?() {
        do  {
            //MARK: - Create 'autospoto.db' in {home}/Library/Application Support/AutoSpoto
            let fileManager = FileManager.default
            let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            guard let directoryURL = appSupportURL?.appendingPathComponent("AutoSpoto") else {
                throw AutoSpotoError.errorGettingAutoSpotoDB
            }
            try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            
            let homeDirectory = "\(NSHomeDirectory())"
            let chatDatabaseString = "\(homeDirectory)/Library/Messages/chat.db"
            
            // MARK: Open a SQLite database connection
            self.database = try Connection(
                directoryURL.path(percentEncoded: false).appending("autospoto.db"),
                readonly: false
            )
            
            try database.execute("attach '\(chatDatabaseString)' as cdb")
            
            // Execute the "CREATE TABLE IF NOT EXISTS" statement
            try database.execute("""
                CREATE TABLE IF NOT EXISTS CREATED_PLAYLISTS (
                    chatID INTEGER,
                    spotifyPlaylistID TEXT,
                    lastUpdated TEXT
                )
            """)
        } catch let error {
            assertionFailure("Error with database: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func extractChatFromPath(input: String) -> String? {
        guard let rangeStart = input.range(of: "chat"),
              let rangeEnd = input.range(of: "%", range: rangeStart.upperBound..<input.endIndex) else {
            return nil
        }
        
        let startIndex = rangeStart.upperBound
        let endIndex = rangeEnd.lowerBound
        let extractedText = input[startIndex..<endIndex]
        
        return String(extractedText)
    }
    
    private func extractChatFromChatDB(input: String) -> String? {
        guard let range = input.range(of: "chat") else {
            return nil
        }
        
        let startIndex = range.upperBound
        let extractedText = input[startIndex...]
        
        return String(extractedText)
    }
    
    private func imageToBase64(filePath: String) -> String? {
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
    
    private func getGroupImageFilePaths() -> DataFrame {
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
            
            let groupChatsWithImage = groupChatImages.joined(groupChats, on: "MessageID", kind: .left)
            var groupChatToUI = groupChatsWithImage.selecting(columnNames: "left.Base64Image", "right.ChatId", "right.ChatName")
            
            groupChatToUI.renameColumn("left.Base64Image", to: "image")
            groupChatToUI.renameColumn("right.ChatId" , to: "chatID")
            groupChatToUI.renameColumn("right.ChatName", to: "chatName")
            let playlistDataFrame = retrievePlaylistsDataFrame()
            
            var finalGroupChatTable = groupChatToUI.joined(playlistDataFrame, on: "chatID", kind: .left)
            
            finalGroupChatTable.renameColumn("left.image", to: "image")
            finalGroupChatTable.renameColumn("left.chatName" , to: "chatName")
            finalGroupChatTable.renameColumn("right.spotifyPlaylistID" , to: "playlistID")
            finalGroupChatTable.renameColumn("right.lastUpdated" , to: "lastUpdated")
            
            let renamedFinalGroupChatTable = finalGroupChatTable.selecting(columnNames: "image", "chatID", "chatName", "playlistID", "lastUpdated")
            
            return try renamedFinalGroupChatTable.jsonRepresentation()
            
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
    
    func fetchIndividualChats() async -> [Chat] {
        do {
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
            
            let contactsDataFrame: DataFrame = [
                "firstName": contactsRowsTuple.map { $0.firstName }.isEmpty ? [""] : contactsRowsTuple.map { $0.firstName },
                "lastName": contactsRowsTuple.map { $0.lastName }.isEmpty ? [""] : contactsRowsTuple.map { $0.lastName },
                "contactInfo": contactsRowsTuple.map { $0.contactInfo }.isEmpty ? [""] : contactsRowsTuple.map { $0.contactInfo },
                "imageBlob": contactsRowsTuple.map { $0.imageBlob }.isEmpty ? [""] : contactsRowsTuple.map { $0.imageBlob }
            ]
            
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
                   let range = guIDrow.range(of: "iMessage;-;") {
                    //this is the data without the 'iMessage;-;' prefix
                    let parsedData = String(guIDrow[range.upperBound...])
                    
                    if !parsedData.isValidEmail() {
                        contactInfo = parsedData.digits
                    }
                    
                    chatRowsTuple.append((contactInfo: contactInfo, chatID: chat[chatID])) //TODO: fix this
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
    
    
    func insertSpotifyPlaylistDB(from createdSpotifyPlaylistID: String, selectedChatID: [Int]){
        let chatID = Expression<Int>("chatID")
        let spotifyPlaylistID = Expression<String?>("spotifyPlaylistID")
        
        let playlistsTable = Table("CREATED_PLAYLISTS")
        
        do {
            try selectedChatID.forEach{ ChatID in
                let rowid = try database.run(playlistsTable.insert(chatID <- ChatID, spotifyPlaylistID <- createdSpotifyPlaylistID))
                print("inserted id: \(rowid)")
            }
        } catch {
            print("update failed: \(error)")
        }
        
    }
    
    func updateLastUpdatedDB(from createdSpotifyPlaylistID: String){
        let spotifyPlaylistID = Expression<String?>("spotifyPlaylistID")
        let lastUpdated = Expression<String?>("lastUpdated")
        
        let playlistsTable = Table("CREATED_PLAYLISTS")
        let playlistQuery = playlistsTable.filter(spotifyPlaylistID==createdSpotifyPlaylistID)
        
        let currentDate = Date()  // Get the current date
        let dateFormatter = DateFormatter()  // Create a date formatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // Set the desired date format

        let dateString = dateFormatter.string(from: currentDate)
        do {
            let rowid = try database.run(playlistQuery.update(lastUpdated <- dateString))
            print("inserted id: \(rowid)")
        } catch {
            print("update failed: \(error)")
        }
    }
    
    
}
