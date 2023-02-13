//
//  ChooseMusicStreamingServiceView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct ChooseMusicStreamingServiceView: View {
    @State private var elementTransitionOpacity: CGFloat = 0

    @State private var showSpotifyLoginSheet: Bool = false
    @State private var spotifyAccessToken: String?
    
    var body: some View {
        VStack {
            Text(AutoSpotoConstants.Strings.CHOOSE_MUSIC_STREAMING_SERVICE)
                .font(.josefinSansSemibold(30))
                .foregroundColor(.white)
                .padding(.bottom, 60)

            VStack(spacing: 12) {
                Button {
                    showSpotifyLoginSheet = true
                } label: {
                    HStack {
                        Image("spotify-logo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 8)

                        Text(AutoSpotoConstants.Strings.CONNECT_WITH_SPOTIFY)
                            .foregroundColor(.white)
                            .font(.josefinSansRegular(18))

                    }
                    .padding(12)
                    .background(in: RoundedRectangle(cornerRadius: 10))
                    .backgroundStyle(Color.spotifyGreen)
                    .frame(width: 400)
                }
                .buttonStyle(.plain)

                Button {
                    print("pressed apple music")
                } label: {
                    HStack {
                        Image("apple-logo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 8)

                        Text(AutoSpotoConstants.Strings.CONNECT_WITH_APPLE_MUSIC)
                            .foregroundColor(.white)
                            .font(.josefinSansRegular(18))

                    }
                    .padding(12)
                    .background(in: RoundedRectangle(cornerRadius: 10))
                    .backgroundStyle(Color.appleMusicOragne)
                    .frame(width: 300)
                }
                .buttonStyle(.plain)

                if let spotifyAccessToken = spotifyAccessToken {
                    Text(spotifyAccessToken)
                }
            }
        }
        .opacity(elementTransitionOpacity)
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
        .sheet(
            isPresented: $showSpotifyLoginSheet,
            content: {
                SpotifyLoginView(
                    spotifyAccessToken: $spotifyAccessToken,
                    isVisible: $showSpotifyLoginSheet
                )
            }
        )
    }
}
