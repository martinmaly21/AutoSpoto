//
//  SpotifyLoginView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct SpotifyLoginView: View {
    @Binding var isVisible: Bool

    private var spotifyLoginURL: URL {
        //Not exactly sure where this is from?
        let redirect = "spotify-api-example-app%3A%2F%2F"
        let securityString = randomSecurityString()

        guard let url = URL(string: "https://accounts.spotify.com/en/authorize?client_id=\(clientID)&response_type=code&redirect_uri=\(redirect)&scope=playlist-modify-public&show_dialog=True&state=\(securityString)") else {
            fatalError("Could not construct URL")
        }

        return url
    }

    var body: some View {
        VStack {
            WebView(url: spotifyLoginURL)
            Button(
                AutoSpotoConstants.Strings.CANCEL,
                action: {
                    isVisible = false
                }
            )
        }
        .frame(
            width: AutoSpotoConstants.Dimensions.loginWithSpotifyWindowWidth,
            height: AutoSpotoConstants.Dimensions.loginWithSpotifyWindowHeight
        )
    }

    func randomSecurityString() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<16).map{ _ in letters.randomElement()! })
    }
}
