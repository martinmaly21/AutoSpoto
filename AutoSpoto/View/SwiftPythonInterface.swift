//
//  SwiftPythonInterface.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-01.
//

import Foundation

import PythonKit


func SwiftPythonInterface() ->PythonObject{
    let sys = Python.import("sys")
    sys.path.append("/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/")
    let file = Python.import("extract_script")
    let response = file.get_songs(10)
    print(response)
    return(response)
    
    
}
//TODO


