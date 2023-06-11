//
//  CreatePlaylistButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-03-04.
//

import SwiftUI

struct CreatePlaylistButton: View {
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Color.spotifyGreen
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: -3)
                    
                    HStack(spacing: 12) {
                        Image("spotify-logo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.textPrimaryWhite)
                            .frame(width: 40, height: 40)
                        
                        Text(AutoSpotoConstants.Strings.CREATE_PLAYLIST)
                            .font(.josefinSansSemibold(18))
                    }
                    .padding(.horizontal, 30)
                    
                    .foregroundColor(Color.textPrimaryWhite)
                }
                .frame(height: height)
                .frame(width: width)
            }
        )
        .buttonStyle(.borderless)
        .contentShape(Rectangle())
    }
}
