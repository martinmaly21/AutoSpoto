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
    @Binding var userAuthorizedSpotify: Bool

    var body: some View {
        VStack {
            if !KeychainManager.authenticationTokenExists {
                Text(AutoSpotoConstants.Strings.CHOOSE_MUSIC_STREAMING_SERVICE)
                    .font(.josefinSansSemibold(30))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 60)

                HStack(spacing: 12) {
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
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 35)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(12)
                    .background(Color.spotifyGreen)
                    .background(in: RoundedRectangle(cornerRadius: 10))
                    .clipShape(Capsule())

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

                            Text(AutoSpotoConstants.Strings.COMING_SOON)
                                .padding(.horizontal, 5)
                                .foregroundColor(.appleMusicOrange)
                                .font(.josefinSansRegular(18))
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 35)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(12)
                    .background(Color.appleMusicOrange)
                    .background(in: RoundedRectangle(cornerRadius: 10))
                    .clipShape(Capsule())
                    .disabled(true)
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
                SpotifyLoginView(isVisible: $showSpotifyLoginSheet, userAuthorizedSpotify: $userAuthorizedSpotify)
            }
        )
    }
}
