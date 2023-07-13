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
    //this closure is called when the "AutoSpoto-PlaylistUpdater" updates autospoto.db
    internal let onTrackedChatsDBUpdatedOutsideOfApp: (() -> Void)?
    //this flag prevents the 'onTrackedChatsDBUpdatedOutsideOfApp' closure from running from updates to autospoto.db via the app
    private var ignoreTrackedChatsUpdate = true
    internal var trackedChats: DataFrame? {
        willSet {
            if newValue != trackedChats {
                guard !ignoreTrackedChatsUpdate else {
                    ignoreTrackedChatsUpdate = false
                    return
                }
                onTrackedChatsDBUpdatedOutsideOfApp?()
            }
        }
    }
    
    init(onTrackedChatsDBUpdatedOutsideOfApp: (() -> Void)? = nil) {
        self.onTrackedChatsDBUpdatedOutsideOfApp = onTrackedChatsDBUpdatedOutsideOfApp
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
                    lastUpdated DOUBLE
                )
            """)
        } catch let error {
            fatalError("Could not initialize autospoto.db: \(error.localizedDescription)")
        }
        
        if onTrackedChatsDBUpdatedOutsideOfApp != nil {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTrackedChats), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTrackedChats() {
        trackedChats = retrieveTrackedChats()
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
    
    func fetchGroupChats() async -> [Chat] {
        do {
            var contactsRowsTuple = [(chatID: Int, displayName: String?, guID: String, messageID: String?)]()
            
            let chat_ids = Expression<Int?>("ROWID")
            let chat_name = Expression<String?>("display_name")
            let guid = Expression<String?>("guid")
            let chatTable = Table("chat")
            
            let query = chatTable.select(chat_ids, chat_name, guid).filter(guid.like("%chat%"))
            
            for groupChat in try database.prepare(query){
                if let chatID = groupChat[chat_ids],
                   let guID = groupChat[guid],
                   let messageID = extractChatFromChatDB(input: guID) {
                    let name = groupChat[chat_name]
                    contactsRowsTuple.append((chatID: chatID, displayName: name, guID: guID, messageID: messageID))
                }
            }
            let groupChats: DataFrame = [
                "ChatId": contactsRowsTuple.map { $0.chatID },
                "ChatName": contactsRowsTuple.map { $0.displayName},
                "ContactInfo": contactsRowsTuple.map { $0.guID },
                "MessageID" : contactsRowsTuple.map { $0.messageID }
            ]
            
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
            
            renamedFinalGroupChatTable = renamedFinalGroupChatTable.grouped(by: "MessageID").mapGroups({slice in
                var df = DataFrame()
                df["ids", [Int].self] = Column(name: "ids", contents: [slice["chatID"].compactMap { $0 as? Int }])
                df["name", String?.self] = Column(name: "name", contents: [slice["chatName"].first as? String])
                df["nameID", String.self] = Column(name: "nameID", contents: [slice["MessageID"].first as! String])
                df["imageBlob", String?.self] = Column(name: "imageBlob", contents: [slice["image"].first as? String])
                df["spotifyPlaylistID", String?.self] = Column(name: "spotifyPlaylistID", contents: [slice["playlistID"].first as? String])
                df["lastUpdated", Double?.self] = Column(name: "lastUpdated", contents: [slice["lastUpdated"].first as? Double])
                return df
            }).ungrouped()
            
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
    
    public func retrieveTrackedChats() -> DataFrame {
        do {
            let chatID = Expression<Int>("chatID")
            let spotifyPlaylistID = Expression<String?>("spotifyPlaylistID")
            let lastUpdated = Expression<Double?>("lastUpdated")
            
            let playlistsTable = Table("CREATED_PLAYLISTS")
            let allPlaylistsTable = playlistsTable.select(chatID, spotifyPlaylistID, lastUpdated)
            let playlistsRows = try database.prepare(allPlaylistsTable)
            
            var playlistsRowsTuple = [(chatID: Int?, spotifyPlaylistID: String?, lastUpdated: Double?)]()
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
    
    func insert(_ spotifyPlaylistID: String, for selectedChatIDs: [Int]) {
        let chatIDExpression = Expression<Int>("chatID")
        let spotifyPlaylistIDExpression = Expression<String?>("spotifyPlaylistID")
        let playlistsTable = Table("CREATED_PLAYLISTS")
        
        do {
            try selectedChatIDs.forEach{ chatID in
                try database.run(playlistsTable.insert(chatIDExpression <- chatID, spotifyPlaylistIDExpression <- spotifyPlaylistID))
                ignoreTrackedChatsUpdate = true
            }
        } catch {
            #warning("Handle error")
        }
    }
    
    func remove(_ spotifyPlaylistID: String) {
        let spotifyPlaylistIDExpression = Expression<String?>("spotifyPlaylistID")
        let playlistsTable = Table("CREATED_PLAYLISTS")
        let playlistQuery = playlistsTable.filter(spotifyPlaylistIDExpression == spotifyPlaylistID)

        do {
            try database.run(playlistQuery.delete())
            ignoreTrackedChatsUpdate = true
        } catch {
            #warning("Handle error")
        }
    }
    
    func updateLastUpdated(for spotifyPlaylistID: String, with lastUpdatedDouble: Double) {
        let spotifyPlaylistIDExpression = Expression<String?>("spotifyPlaylistID")
        let lastUpdatedExpression = Expression<Double?>("lastUpdated")
        let playlistsTable = Table("CREATED_PLAYLISTS")
        let playlistQuery = playlistsTable.filter(spotifyPlaylistIDExpression == spotifyPlaylistID)
        
        do {
            try database.run(playlistQuery.update(lastUpdatedExpression <- lastUpdatedDouble))
            ignoreTrackedChatsUpdate = true
        } catch {
            #warning("Handle error")
        }
    }
}
