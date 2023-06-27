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
    @Binding var userAuthorizedDiskAccess: Bool
    
    //used for polling for permission changes
    @State var currentDate = Date.now
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
                .frame(height: 80)
            Text(AutoSpotoConstants.Strings.JUST_A_COUPLE_THINGS_TEXT)
                .font(.josefinSansSemibold(32))
                .foregroundColor(.textPrimaryWhite)
            
            DiskAccessRequestCell(userAuthorizedDiskAccess: $userAuthorizedDiskAccess)
            
            SpotifyAccessRequestCell(userAuthorizedSpotify: $userAuthorizedSpotify, userAuthorizedDiskAcess: $userAuthorizedDiskAccess)
            
            if userAuthorizedSpotify && userAuthorizedDiskAccess {
                Text(AutoSpotoConstants.Strings.ONBOARDING_SUCCESS)
                    .font(.josefinSansRegular(24))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.top, 50)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 18)
        .opacity(elementTransitionOpacity)
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
        .onReceive(timer) { input in
            withAnimation {
                //disk access
                userAuthorizedDiskAccess = DiskAccessManager.userAuthorizedDiskAccess
            }
        }
    }
}
