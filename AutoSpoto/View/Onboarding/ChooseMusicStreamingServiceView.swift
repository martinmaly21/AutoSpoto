//
//  ChooseMusicStreamingServiceView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct ChooseMusicStreamingServiceView: View {
    @State private var elementTransitionOpacity: CGFloat = 0

    @Binding var userAuthorizedSpotify: Bool

    var body: some View {
        VStack {
            if !SpotifyTokenManager.authenticationTokenExists {
                Text(AutoSpotoConstants.Strings.CONNECT_YOUR_SPOTIFY)
                    .font(.josefinSansSemibold(30))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 60)

                HStack(spacing: 12) {
                    Button {
                        
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
                }
            } else {
                //connected to spotify
                Text(AutoSpotoConstants.Strings.SUCCESS)
                    .font(.josefinSansSemibold(40))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 60)

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
        
    }
}
