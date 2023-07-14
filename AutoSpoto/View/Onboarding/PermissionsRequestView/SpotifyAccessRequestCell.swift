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
    @Binding var userAuthorizedPlaylistUpdater: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(AutoSpotoConstants.Strings.SPOTIFY_PERMISSION_TITLE)
                    .font(.josefinSansSemibold(26))
                    .foregroundColor(.textPrimaryWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 16)
                    .strikethrough(userAuthorizedSpotify, pattern: .solid)
                    .opacity(userAuthorizedSpotify ? 0.5 : 1)
                
                if userAuthorizedSpotify {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.green)
                }
            }
            
            if userAuthorizedDiskAcess && userAuthorizedPlaylistUpdater && !userAuthorizedSpotify {
                
                Text(AutoSpotoConstants.Strings.SPOTIFY_PERMISSION_SUBTITLE)
                    .font(.josefinSansRegular(18))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        Image("spotify-logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.bottom, 30)
                        
                        OnboardingButton(
                            title: AutoSpotoConstants.Strings.CONNECT_WITH_SPOTIFY,
                            action: {
                                showSpotifyLoginSheet = true
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
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.thickMaterial, lineWidth: 2)
                    )
                    .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.regularMaterial, lineWidth: 2)
        )
        .cornerRadius(10)
        .opacity(userAuthorizedDiskAcess && userAuthorizedPlaylistUpdater ? 1 : 0.1)
        .sheet(
            isPresented: $showSpotifyLoginSheet,
            content: {
                SpotifyLoginView(isVisible: $showSpotifyLoginSheet, userAuthorizedSpotify: $userAuthorizedSpotify)
            }
        )
    }
}
