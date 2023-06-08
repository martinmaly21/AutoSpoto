//
//  SpotifyLoginView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct SpotifyLoginView: View {
    @Binding var isVisible: Bool
    @Binding var userAuthorizedSpotify: Bool

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

            SpotifyWebView(isVisible: $isVisible, userAuthorizedSpotify: $userAuthorizedSpotify)
        }
        .frame(
            width: AutoSpotoConstants.Dimensions.loginWithSpotifyWindowWidth,
            height: AutoSpotoConstants.Dimensions.loginWithSpotifyWindowHeight
        )
    }
}
