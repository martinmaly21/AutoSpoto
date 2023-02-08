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

func Login()->PythonObject{
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let spotify_api = Python.import("spotify_apis")
    let user_info = spotify_api.Spotiy().login()
    return user_info
}

func ExtractScript(chat_id: Int) ->PythonObject{
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let file = Python.import("extract_script")
    let tracks = file.get_songs(chat_id)
    return(tracks)
    
    
}

//maybe playlist_id can be string. Will need to see what the best way to pass objects/variables between functions
func AddSongsToPlaylist(playlist_id: PythonObject, tracks: PythonObject)->PythonObject{
    
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let spotify_api = Python.import("spotify_apis")
    let DB = Python.import("db")
    
    //Hard coded values right now for testing
    let response = spotify_api.Spotiy().update_playlist(playlist_id, tracks, DB.db())
    
    DB.db().close_connection()
    print(response)
    return(response)
    // print(response)
   // return(response)
    
}

func CreatePlaylist(name: String, description: String, chat_id: Int)-> PythonObject{
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let spotify_api = Python.import("spotify_apis")
    let DB = Python.import("db")
    let response = spotify_api.Spotiy().create_playlist(spotify_api.Spotiy().user_id, name, description, chat_id, DB.db())
    
    DB.db().close_connection()
    print(response)
    return(response)
    
}

func DeletePlaylist(playlist_id: String){
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let spotify_api = Python.import("spotify_apis")
    let DB = Python.import("db")
    spotify_api.Spotiy().current_user_unfollow_playlist(playlist_id, DB.db())
    DB.db().close_connection()
}

func DisplayPlaylists() ->PythonObject{
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let DB = Python.import("db")
    let response = DB.db().display_playlists()
    return response
}

func ViewGroupChat()->PythonObject{
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let DB = Python.import("db")
    
    let response = DB.db().retrieve_group_chat()
    
    return response
}

func ViewSingleChat()->PythonObject{
    
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let DB = Python.import("db")
    
    let response = DB.db().retrieve_single_chat()
    
    return response
    
}






//TODO


