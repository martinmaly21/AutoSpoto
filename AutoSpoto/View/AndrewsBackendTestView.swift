//
//  AndrewsBackendTestView.swift
//  AutoSpoto
//
//  Created by Andrew Caravaggio on 2023-02-03.
//

import SwiftUI
import PythonKit

struct AndrewsBackendTestView: View {
    @State private var showResult: Bool = false
    var body: some View {
        VStack{
            Button(action:{
                let _ = SwiftPythonInterface.login()
                showResult.toggle()
            },
                   label:{
                Text("My Button")
            })
            if showResult{
                Text(String("\(SwiftPythonInterface.viewSingleChat())"))
            }
        }
    }
}
