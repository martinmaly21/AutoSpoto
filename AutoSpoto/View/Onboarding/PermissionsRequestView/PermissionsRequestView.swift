//
//  PermissionsRequestView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct PermissionsRequestView: View {
    @State private var elementTransitionOpacity: CGFloat = 0
    
    @Binding var userAuthorizedSpotify: Bool
    @Binding var userAuthorizedDiskAcess: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(AutoSpotoConstants.Strings.JUST_A_COUPLE_THINGS_TEXT)
                .font(.josefinSansSemibold(32))
                .foregroundColor(.textPrimaryWhite)
            
            DiskAccessRequestCell(userAuthorizedDiskAcess: $userAuthorizedDiskAcess)
            
            SpotifyAccessRequestCell(userAuthorizedSpotify: $userAuthorizedSpotify, userAuthorizedDiskAcess: $userAuthorizedDiskAcess)
        }
        .padding(.horizontal, 20)
        .opacity(elementTransitionOpacity)
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
    }
}
