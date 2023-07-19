//
//  PermissionsRequestView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI
import LaunchAgent

struct PermissionsRequestView: View {
    @State private var elementTransitionOpacity: CGFloat = 0
    
    @Binding var userAuthorizedSpotify: Bool
    @Binding var userAuthorizedDiskAccess: Bool
    @Binding var userAuthorizedPlaylistUpdater: Bool
    
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
            
            AutoSpotoDiskAccessRequestCell(userAuthorizedDiskAccess: $userAuthorizedDiskAccess)
            
            PlaylistUpdaterDiskAccessRequestCell(
                userAuthorizedDiskAccess: $userAuthorizedDiskAccess,
                userAuthorizedPlaylistUpdater: $userAuthorizedPlaylistUpdater
            )
            
            SpotifyAccessRequestCell(
                userAuthorizedSpotify: $userAuthorizedSpotify,
                userAuthorizedDiskAcess: $userAuthorizedDiskAccess,
                userAuthorizedPlaylistUpdater: $userAuthorizedPlaylistUpdater
            )
            
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
            
            //set up launch agent
            let launchAgent = LaunchAgent(label: "com.autospoto.app.playlistupdater", program: [])
        }
        .onReceive(timer) { input in
            withAnimation {
                //disk access
                userAuthorizedDiskAccess = DiskAccessManager.userAuthorizedDiskAccess
                userAuthorizedPlaylistUpdater = DiskAccessManager.userAuthorizedPlaylistUpdaterDiskAccess
            }
        }
    }
}
