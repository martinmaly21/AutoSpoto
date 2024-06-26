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
    internal var trackedChats: DataFrame! {
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
    private var timer: Timer?
    
    init?(onTrackedChatsDBUpdatedOutsideOfApp: (() -> Void)? = nil) {
        self.onTrackedChatsDBUpdatedOutsideOfApp = onTrackedChatsDBUpdatedOutsideOfApp
        do  {
            //MARK: - Create 'autospoto.db' in {home}/Library/Application Support/AutoSpoto (if it doesn't exist)
            guard let autoSpotoURL = DiskAccessManager.autoSpotoURL,
            let autoSpotoDBURL = DiskAccessManager.autoSpotoDBURL,
            let chatDBURL = DiskAccessManager.chatDBURL else {
                fatalError("Could not get autoSpotoURL")
            }
            
            //print(UserDefaultsManager.libraryBookmarkData)
            DiskAccessManager.startAccessingSecurityScopedResource()
            try FileManager.default.createDirectory (at: autoSpotoURL, withIntermediateDirectories: true, attributes: nil)
            DiskAccessManager.stopAccessingSecurityScopedResource()

            DiskAccessManager.startAccessingSecurityScopedResource()
            // MARK: Open a SQLite database connection
            self.database = try Connection(
                autoSpotoDBURL.path(percentEncoded: false),
                readonly: false
            )
            DiskAccessManager.stopAccessingSecurityScopedResource()
            
            DiskAccessManager.startAccessingSecurityScopedResource()
            try database.execute("attach '\(chatDBURL.path())' as cdb")
            DiskAccessManager.stopAccessingSecurityScopedResource()
            
            // Execute the "CREATE TABLE IF NOT EXISTS" statement
            DiskAccessManager.startAccessingSecurityScopedResource()
            try database.execute("""
                CREATE TABLE IF NOT EXISTS CREATED_PLAYLISTS (
                    chatID INTEGER,
                    spotifyPlaylistID TEXT,
                    lastUpdated DOUBLE
                )
            """)
            DiskAccessManager.stopAccessingSecurityScopedResource()
        } catch let error {
            print("Could not initialize autospoto.db: \(error.localizedDescription)")
            return nil
        }
        
        if onTrackedChatsDBUpdatedOutsideOfApp != nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTrackedChats), userInfo: nil, repeats: true)
        }
    }
    
    public func deleteAutoSpotoDatabase() {
        timer?.invalidate()
        
        do {
            if let autoSpotoDBURL = DiskAccessManager.autoSpotoDBURL {
                DiskAccessManager.startAccessingSecurityScopedResource()
                try FileManager.default.removeItem(at: autoSpotoDBURL)
                DiskAccessManager.stopAccessingSecurityScopedResource()
            }
        } catch let error {
            print("Error deleting autospoto db: \(error.localizedDescription)")
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
    
    internal func extractChatFromChatDB(input: String) -> String? {
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
    
    internal func getGroupImageFilePaths() -> DataFrame {
        var directories = [(DirPath:(String)?, ChatId: (String)?, image:(String)?)]()
        do {
            //temporarily disable group chat photos so sandbox is functional
            directories = [("", "", "")]
//            if let imageFilePathsURL = DiskAccessManager.imageFilePathsURL {
//                DiskAccessManager.startAccessingSecurityScopedResource()
//                let contents = try FileManager.default.contentsOfDirectory(at: imageFilePathsURL, includingPropertiesForKeys: nil)
//                DiskAccessManager.stopAccessingSecurityScopedResource()
//                for fileURL in contents {
//                    let directory = fileURL.path
//                    if directory.hasSuffix("GroupPhotoImage.png"){
//                        directories.append((DirPath:directory, ChatId:extractChatFromPath(input: directory), image:imageToBase64(filePath: directory) ))
//                    }
//                }
//            }
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
            //
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
            //
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
            //
        }
    }
    
    public func fetchSpotifyTracksWithNoMetadata(
        for chatIDs: [Int]
    ) async -> [Track] {
        var tracks: [Track] = []
        
        chatIDs.forEach { selectedChatIDs in
            tracks += fetchTracksFromChats(from: selectedChatIDs)
        }
        
        //remove duplicates
        tracks = tracks.unique
        
        //sort tracks
        tracks.sort()
        
        return tracks
    }
    
    private func extractSpotifyTrackID(from url: String) -> String? {
        let pattern = #"https:\/\/open\.spotify\.com\/track\/(?![a-zA-Z0-9]{19}WHt)[a-zA-Z0-9]{22}"#
        let linkPattern = #"https:\/\/spotify\.link\/[a-zA-Z0-9]{11}"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        
        guard let linkRegex = try? NSRegularExpression(pattern: linkPattern) else {
            return nil
        }

        let range = NSRange(location: 0, length: url.utf16.count)
        if let match = regex.firstMatch(in: url, options: [], range: range) {
            let trackIDRange = match.range(at: 0)
            if let trackIDRange = Range(trackIDRange, in: url) {
                return String(url[trackIDRange])
            }
        }
        else if let matchLink = linkRegex.firstMatch(in: url, options: [], range: range) {
            let trackIDRange = matchLink.range(at: 0)
            if let trackIDRange = Range(trackIDRange, in: url) {
                return String(url[trackIDRange])
            }
        }

        return nil
    }
    
    
    private func formatDate(from posixDate: Int) -> Date {
        let inputDateInSeconds = Double(posixDate) / 1_000_000_000.0
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        let referenceDateTimeIntervalSince1970 = referenceDate.timeIntervalSince1970
        let outputTimeInterval = referenceDateTimeIntervalSince1970 + inputDateInSeconds
        let outputDate = Date(timeIntervalSince1970: outputTimeInterval)
        
        return outputDate
    }
    
    private func removeSpotifyPrefix(from url: String) -> String {
        let prefix = "https://open.spotify.com/track/"
        let linkPrefix = "https://spotify.link/"
        
        if url.hasPrefix(prefix) {
            let startIndex = url.index(url.startIndex, offsetBy: prefix.count)
            return String(url[startIndex...])
        }else if url.hasPrefix(linkPrefix){
            let startIndex = url.index(url.startIndex, offsetBy: linkPrefix.count)
            return String(url[startIndex...])
        }
        return url
    }
    
    private func fetchTracksFromChats(from selectedChatIDs: Int) ->[Track] {
        do {
            let messages = Table("message")
            let handleTable = Table("handle")
            let chatMessageJoin = Table("chat_message_join")
            let handleID = Expression<Int>("handle_id")
            let payloadData = Expression<Data?>("attributedBody")
            let row  = Expression<Int>("ROWID")
            let date = Expression<Int>("date")
            let chatID = Expression<Int>("chat_id")
            let messageID = Expression<Int>("message_id")
            
            var tracks: [Track] = []
            let chosenChat = selectedChatIDs
            for message in try database
                .prepare(messages.select(date, payloadData, chatID)
                    .filter(payloadData != nil)
                    .where(chatMessageJoin[chatID]==chosenChat)
                    .join(.leftOuter, handleTable, on: handleTable[row]==messages[handleID])
                    .join(.leftOuter, chatMessageJoin, on: chatMessageJoin[messageID] == messages[row])) {
                
                guard let attributedBodyData = message[payloadData] else {
                    continue
                }
                
                let decodedPayload = String(decoding: attributedBodyData, as: UTF8.self)
                
                if let url = extractSpotifyTrackID(from: decodedPayload){
                    let track = removeSpotifyPrefix(from: url)
                    let formattedDate = formatDate(from: message[date])
                    tracks.append(Track(spotifyID: track, timeStamp: formattedDate))
                }
            }
            
            return tracks
        } catch let error {
            fatalError("Error fetching songs from chats: \(error.localizedDescription)")
        }
    }
}
