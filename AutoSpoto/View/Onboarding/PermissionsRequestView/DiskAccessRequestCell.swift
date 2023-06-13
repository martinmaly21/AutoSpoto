//
//  DiskAccessRequestCell.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-13.
//

import SwiftUI

struct DiskAccessRequestCell: View {
    @Binding var userAuthorizedDiskAcess: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Image("GenericFolderIcon")
                    .resizable()
                    .frame(width: 200, height: 200)

                Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_TITLE)
                    .font(.josefinSansSemibold(30))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 10)

                Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_SUBTITLE)
                    .font(.josefinSansLight(18))
                    .foregroundColor(.textPrimaryWhite)
                    .padding(.bottom, 10)
                
                OnboardingButton(
                    title: AutoSpotoConstants.Strings.OPEN_SETTINGS,
                    action: {
                        NSWorkspace.shared.open(AutoSpotoConstants.URL.fullDiskAccess)
                    }
                )
            }
        }
        .background(Color.black)
        .frame(maxWidth: .infinity)
        .frame(height: 400)
    }
}
