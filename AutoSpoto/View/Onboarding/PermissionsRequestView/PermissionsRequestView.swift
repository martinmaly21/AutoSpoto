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
            Text(AutoSpotoConstants.Strings.PERMISSIONS_VIEW_TITLE)
                .font(.josefinSansSemibold(32))
                .foregroundColor(.textPrimaryWhite)
                .padding(.top, 30)
            
            DiskAccessRequestCell(userAuthorizedDiskAcess: $userAuthorizedDiskAcess)
            
            SpotifyAccessRequestCell(userAuthorizedSpotify: $userAuthorizedSpotify)
        }
        .opacity(elementTransitionOpacity)
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
    }
}
