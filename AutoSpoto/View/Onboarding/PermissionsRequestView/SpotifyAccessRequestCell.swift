//
//  SpotifyAccessRequestCell.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-13.
//

import SwiftUI

struct SpotifyAccessRequestCell: View {
    @State private var showSpotifyLoginSheet: Bool = false
    @Binding var userAuthorizedSpotify: Bool
    
    var body: some View {
        ZStack {
            if userAuthorizedSpotify {
                Text("TODO")
            } else {
                Text("BLAH")
            }
        }
        .background(Color.black)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .onChange(of: KeychainManager.authenticationTokenExists) { newValue in
            userAuthorizedSpotify = newValue
        }
    }
}
