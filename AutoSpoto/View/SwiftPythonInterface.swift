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

class SwiftPythonInterface {
    static let shared = SwiftPythonInterface()

    //TODO: will need to retrieve this from the user's machine
    private var filepath: String = "/Users/martinmaly/AutoSpoto/AutoSpoto/Backend/"

    //Instance variables

    private static var spotify_api: PythonObject {
        let sys = Python.import("sys")
        sys.path.append(shared.filepath)
        return Python.import("spotify_apis")
    }

    private static var extract_script: PythonObject {
        let sys = Python.import("sys")
        sys.path.append(shared.filepath)
        return Python.import("extract_script")
    }

    private static var db: PythonObject {
        let sys = Python.import("sys")
        sys.path.append(shared.filepath)
        return Python.import("db")
    }

    static func login() -> PythonObject {
        let user_info = spotify_api.Spotiy().login()
        return user_info
    }

    static func extractScript(chat_id: Int) -> PythonObject {
        let tracks = extract_script.get_songs(chat_id)
        return(tracks)
    }

    //maybe playlist_id can be string. Will need to see what the best way to pass objects/variables between functions
    static func addSongsToPlaylist(playlist_id: PythonObject, tracks: PythonObject) -> PythonObject {
        //Hard coded values right now for testing
        let response = spotify_api.Spotiy().update_playlist(playlist_id, tracks, db.db())

        db.db().close_connection()
        print(response)
        return(response)
    }

    static func createPlaylist(name: String, description: String, chat_id: Int) -> PythonObject {
        let response = spotify_api.Spotiy().create_playlist(spotify_api.Spotiy().user_id, name, description, chat_id, db.db())

        db.db().close_connection()
        print(response)
        return(response)
    }

    static func deletePlaylist(playlist_id: String) {
        spotify_api.Spotiy().current_user_unfollow_playlist(playlist_id, db.db())
        db.db().close_connection()
    }

    static func displayPlaylists() -> PythonObject {
        let response = db.db().display_playlists()
        return response
    }

    static func viewGroupChat() -> PythonObject {
        let response = db.db().retrieve_group_chat()
        return response
    }

    static func viewSingleChat() -> PythonObject {
        let response = db.db().retrieve_single_chat()
        return response
    }

    //TODO: Add more queries if needed
}

