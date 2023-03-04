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
    @Binding var spotifyAccessToken: String?

    var body: some View {
        VStack {
            if spotifyAccessToken == nil {
                Text(AutoSpotoConstants.Strings.CHOOSE_MUSIC_STREAMING_SERVICE)
                    .font(.josefinSansSemibold(30))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 60)

                VStack(spacing: 12) {
                    Button {
                        showSpotifyLoginSheet = true
                    } label: {
                        HStack {
                            Image("spotify-logo")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.textPrimaryWhite)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 8)

                            Text(AutoSpotoConstants.Strings.CONNECT_WITH_SPOTIFY)
                                .foregroundColor(.textPrimaryWhite)
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
                                .foregroundColor(.textPrimaryWhite)
                                .frame(width: 30, height: 30)
                                .padding(.leading, 8)

                            Text(AutoSpotoConstants.Strings.CONNECT_WITH_APPLE_MUSIC)
                                .foregroundColor(.textPrimaryWhite)
                                .font(.josefinSansRegular(18))

                        }
                        .padding(12)
                        .background(in: RoundedRectangle(cornerRadius: 10))
                        .backgroundStyle(Color.appleMusicOrange)
                        .frame(width: 300)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                //connected to spotify
                Text(AutoSpotoConstants.Strings.SUCCESS)
                    .font(.josefinSansSemibold(40))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 60)

                //TODO: Change in future when we allow user to connect with apple music
                Text(AutoSpotoConstants.Strings.CONNECTED_TO_SPOTIFY)
                    .font(.josefinSansSemibold(26))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 60)
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
        .onChange(
            of: spotifyAccessToken,
            perform: { _ in
                if spotifyAccessToken != nil {
                    showSpotifyLoginSheet = false
                }
            }
        )
    }
}
