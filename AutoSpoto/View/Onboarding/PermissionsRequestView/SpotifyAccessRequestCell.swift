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
    @Binding var userAuthorizedDiskAcess: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(AutoSpotoConstants.Strings.SPOTIFY_PERMISSION_TITLE)
                .font(.josefinSansSemibold(26))
                .foregroundColor(.textPrimaryWhite)
                .padding(.top, 8)
            
            Text(AutoSpotoConstants.Strings.SPOTIFY_PERMISSION_SUBTITLE)
                .font(.josefinSansRegular(18))
                .foregroundColor(.textPrimaryWhite)
                .padding(.bottom, 10)
            
            if userAuthorizedDiskAcess {
                HStack(spacing: 20) {
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .center, spacing: 0) {
                            Image("spotify-logo")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .padding(.bottom, 30)
                            
                            OnboardingButton(
                                title: AutoSpotoConstants.Strings.CONNECT_WITH_SPOTIFY,
                                action: {
                                    NSWorkspace.shared.open(AutoSpotoConstants.URL.fullDiskAccess)
                                },
                                width: 220,
                                height: 30
                            )
                            .padding(.bottom, 14)
                            
                            Text(AutoSpotoConstants.Strings.SPOTIFY_ACCESS_BUTTON_INFO)
                                .font(.josefinSansLight(14))
                                .padding(.horizontal, 16.5)
                                .foregroundColor(.textPrimaryWhite)
                        }
                        
                        .background(.regularMaterial)
                        .cornerRadius(8)
                    }
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity)
                .onChange(of: KeychainManager.authenticationTokenExists) { newValue in
                    userAuthorizedSpotify = newValue
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: userAuthorizedDiskAcess ? 400 :  100)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.regularMaterial, lineWidth: 2)
        )
        .cornerRadius(10)
        .opacity(userAuthorizedDiskAcess ? 1 : 0.1)
    }
}
