//
//  PlaylistSummaryView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-10.
//

import SwiftUI
import Kingfisher

struct PlaylistSummaryView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.openURL) private var openURL
    
    let chat: Chat
    let width: CGFloat
    let height: CGFloat
    
    @State private var isModifyingPlaylist = false
    @State private var optInToAutomaticPlaylistUpdates = true
    
    var spotifyPlaylist: SpotifyPlaylist? {
        return chat.spotifyPlaylist
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .shadow(color: .gray.opacity(0.05), radius: 6, x: 4, y: -3)
                .frame(height: height)
                .frame(width: width)
            
            VStack {
                HStack(alignment: .center) {
                    HStack(alignment: .center) {
                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                KFImage(spotifyPlaylist?.imageURL)
                                    .placeholder {
                                        Image("spotify-logo")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.spotifyGreen)
                                            .frame(width: 90, height: 90)
                                    }
                                    .cacheOriginalImage(true)
                                    .fade(duration: 0.25)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 90, height: 90)
                                    .cornerRadius(8)
                                    .aspectRatio(contentMode: .fill)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(spotifyPlaylist?.name ?? AutoSpotoConstants.Strings.CHAT_NAME_PLACEHOLDER)
                                        .font(.josefinSansBold(22))
                                        .font(.headline)
                                    
                                    Button(
                                        action: {
                                            if let url = spotifyPlaylist?.url {
                                                openURL(url)
                                            }
                                        },
                                        label: {
                                            Text(spotifyPlaylist?.url?.absoluteString ?? AutoSpotoConstants.Strings.CHAT_URL_PLACEHOLDER)
                                                .font(.josefinSansRegular(15))
                                                .foregroundColor(.spotifyGreen)
                                                .underline(pattern: .solid)
                                                .lineLimit(1)
                                        }
                                    )
                                    .buttonStyle(.plain)
                                    
//                                    Text(String.localizedStringWithFormat(AutoSpotoConstants.Strings.LAST_UPDATED, chat.lastUpdated?.formatted() ?? AutoSpotoConstants.Strings.LAST_UPDATED_FALLBACK))
//                                        .font(.josefinSansLight(16))
//                                        .font(.headline)
                                }
                                
                                Spacer()
                            }
                        }
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 12) {
                            SyncButton(
                                title: AutoSpotoConstants.Strings.SYNC_TRACKS,
                                action: {
                                    Task {
                                        isModifyingPlaylist = true
                                        await homeViewModel.updatePlaylist(for: chat)
                                        isModifyingPlaylist = false
                                    }
                                }
                            )
                            
                            Button(
                                action: {
                                    Task {
                                        isModifyingPlaylist = true
                                        await homeViewModel.disconnectPlaylist(for: chat)
                                        isModifyingPlaylist = false
                                    }
                                },
                                label: {
                                    Text(AutoSpotoConstants.Strings.DISCONNECT_CHAT_FROM_PLAYLIST)
                                        .font(.josefinSansRegular(15))
                                        .foregroundColor(.errorRed)
                                        .underline(pattern: .solid)
                                }
                            )
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .disabled(isModifyingPlaylist)
            .padding(.horizontal, 16.5)
            .frame(height: height)
            .frame(width: width)
            .redacted(reason: spotifyPlaylist == nil ? .placeholder : [])
        }
    }
}
