//
//  SpotifyLoginContainerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI

struct SpotifyLoginContainerView: View {
    @State var isLoadingWebView = true
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
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.textPrimary)
                            .clipShape(Circle())
                    }
                )
                .buttonStyle(.plain)
                .padding()
            }

            ZStack {
                SpotifyLoginWebView(isVisible: $isVisible, userAuthorizedSpotify: $userAuthorizedSpotify, isLoadingWebView: $isLoadingWebView)
                
                if isLoadingWebView {
                    ProgressView()
                }
            }
        }
        .frame(
            width: AutoSpotoConstants.Dimensions.loginWithSpotifyWindowWidth,
            height: AutoSpotoConstants.Dimensions.loginWithSpotifyWindowHeight
        )
    }
}
