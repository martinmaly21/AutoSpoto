//
//  SpotifyLoginView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct SpotifyLoginView: View {
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            WebView(url: URL(string: "https://google.com")!)
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
}
