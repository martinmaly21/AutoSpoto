//
//  SwiftPythonInterface.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-01.
//
//For all of these to work you need to change the file path for your machine

import Foundation
import PythonKit

//Call this function to sign the user in and save the cache

@MainActor
class SwiftPythonInterface {
    private static var filepath: String {
        let knownFileNameAtDesiredPath = "db.py"
        let knownFileNameArray = knownFileNameAtDesiredPath.split(separator: ".")

        guard let filePath = Bundle.main.url(forResource: String(knownFileNameArray[0]), withExtension: String(knownFileNameArray[1]))?.path() else {
            fatalError("Could not get filePath")
        }
        return filePath.replacingOccurrences(of: knownFileNameAtDesiredPath, with: "")
    }

    static let sys = Python.import("sys")

    //Instance variables
    private static var spotify_api: PythonObject {
        sys.path.append(filepath)
        return Python.import("spotify_apis")
    }

    private static var extract_script: PythonObject {
        sys.path.append(filepath)
        return Python.import("extract_script")
    }

    private static var db: PythonObject {
        sys.path.append(filepath)

        //is it okay to pass in Bundle.main.bundleURL?
        //Not sure if Bundle.main.bundleURL.path() is a constant; Ideally we want it to be
        //so that multiple instances of autospoto.db are not created
        let db_string = "\(filepath)autospoto.db"
        let contactsStringID = "DBD9A071-1507-4104-A7B0-9302B102B4D4"

        return Python.import("db").db(db_string, contactsStringID)
    }

    private static var spotiy: PythonObject {
        guard let cacheUrl = Bundle.main.urls(forResourcesWithExtension: "cache", subdirectory: nil)?.first else {
            fatalError("Could not get .cache url")
        }

        return spotify_api.Spotiy(cacheUrl.path)
    }

    static func user_info() -> PythonObject {
        let user_info = spotify_api.Spotiy().user_info()
        return user_info
    }

    static func extractScript(chat_id: Int, lastUpdated: Bool = false, displayView: Bool = false) -> PythonObject {
        let tracks = extract_script.get_songs(chat_id, lastUpdated, displayView)
        return(tracks)
    }

    static func createPlaylistAndAddSongs(
        playlistImage: String? = nil,
        playlistName: String,
        playlistDescription: String = "",
        chatID: Int
    ) {
        //TODO: pass in playlistPhoto

        let playlistID = SwiftPythonInterface.createPlaylist(
            name: playlistName,
            description: playlistDescription,
            chat_id: chatID
        )

        let _ = addSongsToPlaylist(
            playlist_id: playlistID,
            tracks: extractScript(chat_id: chatID)
        )
    }

    static private func createPlaylist(name: String, description: String, chat_id: Int) -> PythonObject {
        let response = spotiy.create_playlist(spotiy.user_info(), name, description, chat_id, db)

        db.close_connection()
        print(response)
        return(response)
    }

    //maybe playlist_id can be string. Will need to see what the best way to pass objects/variables between functions
    static func addSongsToPlaylist(playlist_id: PythonObject, tracks: PythonObject) -> PythonObject {
        //Hard coded values right now for testing
        let response = spotiy.update_playlist(playlist_id, tracks, db)

        db.close_connection()
        print(response)
        return(response)
    }

    static func deletePlaylist(playlist_id: String) {
        spotiy.current_user_unfollow_playlist(playlist_id, db)
        db.close_connection()
    }

    static func displayPlaylists() -> PythonObject {
        let response = db.display_playlists()
        return response
    }

    static func viewGroupChat() -> PythonObject {
        let response = db.retrieve_group_chat()
        return response
    }

    static func viewSingleChat() -> PythonObject {
        let response = db.retrieve_single_chat()
        return response
    }

    //TODO: Add more queries if needed
}

