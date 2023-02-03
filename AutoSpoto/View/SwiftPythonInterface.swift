//
//  SwiftPythonInterface.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-01.
//
//For all of these to work you need to change the file path for your machine


import Foundation

import PythonKit


func SwiftPythonInterface() ->PythonObject{
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let file = Python.import("extract_script")
    let response = file.get_songs(10)
    return(response)
    
    
}

func AddSongsToPlaylist()->PythonObject{
    
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let spotify_api = Python.import("spotify_apis")
    let DB = Python.import("db")
    
    //Hard coded values right now for testing
    let response = spotify_api.Spotiy().update_playlist("7b4HXoeUVaJtItb3DdmFVD", ["spotify:track:1T1s83GwCXB8aAhqlmhjGM"], DB.db())
    
    DB.db().close_connection()
    print(response)
    return(response)
    // print(response)
   // return(response)
    
}


//TODO


