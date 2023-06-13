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
        VStack {
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
