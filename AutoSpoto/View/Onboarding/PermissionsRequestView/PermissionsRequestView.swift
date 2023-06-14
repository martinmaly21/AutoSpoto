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
    
    //used for polling for permission changes
    @State var currentDate = Date.now
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(AutoSpotoConstants.Strings.JUST_A_COUPLE_THINGS_TEXT)
                .font(.josefinSansSemibold(32))
                .foregroundColor(.textPrimaryWhite)
            
            DiskAccessRequestCell(userAuthorizedDiskAcess: $userAuthorizedDiskAcess)
            
            SpotifyAccessRequestCell(userAuthorizedSpotify: $userAuthorizedSpotify, userAuthorizedDiskAcess: $userAuthorizedDiskAcess)
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
                let hasAccessToChatDB = (try? FileManager.default.contentsOfDirectory(atPath: "\(NSHomeDirectory())/Library/Messages")) != nil
                userAuthorizedDiskAcess = hasAccessToChatDB
                                                                                     
                //spotify access
                userAuthorizedSpotify = KeychainManager.authenticationTokenExists
            }
        }
    }
}
