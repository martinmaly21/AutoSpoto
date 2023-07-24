//
//  AutoSpotoProUpgradeView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI

struct AutoSpotoProUpgradeView: View {
    @Binding var showCreatePlaylistSheet: Bool
    
    @State private var userHasPurchasedLicense: Bool = false
    @State private var isLoadingWebView: Bool = false
    @State private var licenseKey: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if userHasPurchasedLicense {
                Text(AutoSpotoConstants.Strings.ACTIVATE_LICENSE)
                    .font(.josefinSansBold(22))
                    .font(.headline)
                
                Text(AutoSpotoConstants.Strings.ACTIVATE_LICENSE_SUBTITLE)
                    .font(.josefinSansRegular(16))
                    .padding(.bottom, 15)
                
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(AutoSpotoConstants.Strings.LICENSE_KEY)
                        .font(.josefinSansRegular(18))
                    
                    TextField(AutoSpotoConstants.Strings.LICENSE_KEY_PLACEHOLDER, text: $licenseKey)
                        .font(.josefinSansRegular(18))
                }
                .padding(.vertical, 8)
                
                Spacer()
                
                HStack {
                    NotNowButton(action: {
                        showCreatePlaylistSheet = false
                    })
                    
                    Spacer()
                    
                    ActivateLicenseButton(action: {
                        withAnimation {
                            userHasPurchasedLicense = true
                        }
                    })
                    .opacity(userHasPurchasedLicense ? 1 : 0.4)
                }
                
            } else {
                Text(AutoSpotoConstants.Strings.UPGRADE_TO_AUTOSPOTO_PRO_TITLE)
                    .font(.josefinSansBold(22))
                    .font(.headline)
                    
                Text(AutoSpotoConstants.Strings.UPGRADE_TO_AUTOSPOTO_PRO_SUBTITLE)
                    .font(.josefinSansRegular(16))
                    .padding(.bottom, 15)
                    .frame(height: 60)
                
                Divider()
                    .frame(height: 0.5)
                    .overlay(.gray)
                
                ZStack {
                    UpgradeToAutoSpotoProWebView(userHasPurchasedLicense: $userHasPurchasedLicense, isLoadingWebView: $isLoadingWebView)
                    
                    if isLoadingWebView {
                        ProgressView()
                    }
                }
                
                Divider()
                    .frame(height: 0.5)
                    .overlay(.gray)
                
                Spacer()
                
                HStack {
                    NotNowButton(action: {
                        showCreatePlaylistSheet = false
                    })
                    
                    Spacer()
                    
                    ActivateLicenseButton(action: {
                        withAnimation {
                            userHasPurchasedLicense = true
                        }
                    })
                    .opacity(userHasPurchasedLicense ? 1 : 0.4)
                }
            }
        }
        .frame(width: 700, height: 590)
        .padding(.all, 25)
        .padding(25)
    }
}
