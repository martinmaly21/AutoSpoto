//
//  ModifyPlaylistButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-03-04.
//

import SwiftUI

struct ModifyPlaylistButton: View {
    let playlistExists: Bool
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                HStack(spacing: 12) {
                    Image(systemName: playlistExists ? "pencil.circle" : "plus.circle")
                        .resizable()
                        .frame(width: 22, height: 22)

                    Text(playlistExists ? AutoSpotoConstants.Strings.MODIFY_PLAYLIST : AutoSpotoConstants.Strings.CREATE_PLAYLIST)
                        .font(.josefinSansSemibold(18))
                }
                .frame(height: 50)
                .padding(.horizontal, 30)
                .background(Color.primaryBlue)
                .foregroundColor(Color.textPrimaryWhite)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: 4)
            }
        )
        .buttonStyle(.plain)
    }
}
