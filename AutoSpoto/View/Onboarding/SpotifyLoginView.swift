//
//  SpotifyLoginView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct SpotifyLoginView: View {
    @Binding var spotifyAccessToken: String?

    @Binding var isVisible: Bool

    private var spotifyLoginURL: URL {
        //Not exactly sure where this is from?
        let securityString = randomSecurityString()

        guard let url = URL(string: "https://accounts.spotify.com/en/authorize?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)&scope=playlist-modify-public&show_dialog=True&state=\(securityString)") else {
            fatalError("Could not construct URL")
        }

        return url
    }

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Spacer()

                Button(
                    action: {
                        isVisible = false
                    },
                    label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.textPrimary)
                            .clipShape(Circle())
                    }
                )
                .buttonStyle(.plain)
                .padding([.trailing, .top], 5)
            }

            SpotifyWebView(
                spotifyAccessToken: $spotifyAccessToken,
                url: spotifyLoginURL
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
