//
//  AutoSpotoProUpgradeView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI

struct AutoSpotoProUpgradeView: View {
    @Binding var showCreatePlaylistSheet: Bool
    
    @State private var userAlreadyHasLicense: Bool = false
    @State private var userPurchasedLicense: Bool = false
    @State private var isLoadingWebView: Bool = false
    @State private var isValidatingLicense: Bool = false
    @State private var userEnteredInvalidLicense: Bool = false
    @State private var userEnteredValidLicense: Bool = false
    @State private var licenseKey: String = ""
    @State private var retrievedLicenseKey: String?
    @State private var isLoadingReceiptPage: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if userAlreadyHasLicense {
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
                    
                    if userEnteredInvalidLicense {
                        Text(AutoSpotoConstants.Strings.LICENSE_IS_INVALID)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(Color.errorRed)
                    } else if userEnteredValidLicense {
                        Text(AutoSpotoConstants.Strings.LICENSE_IS_VALID)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(Color.spotifyGreen)
                    }
                }
                .padding(.vertical, 8)
                
                Spacer()
                
                HStack {
                    NotNowButton(action: {
                        showCreatePlaylistSheet = false
                    })
                    
                    Spacer()
                    
                    if userEnteredValidLicense {
                        DoneButton(
                            action: {
                                
                            }
                        )
                    } else {
                        ActivateLicenseButton(action: {
                            withAnimation {
                                validateLicense(licenseKey: licenseKey)
                            }
                        })
                    }
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
                    UpgradeToAutoSpotoProWebView(
                        isLoadingWebView: $isLoadingWebView,
                        retrievedLicenseKey: $retrievedLicenseKey,
                        userPurchasedLicense: $userPurchasedLicense
                    )
                    .opacity(userPurchasedLicense ? 0.5 : 1)
                    
                    if isLoadingWebView {
                        ProgressView()
                    }
                    
                    if userPurchasedLicense {
                        VStack(spacing: 6) {
                            ProgressView()
                            
                            if userEnteredValidLicense {
                                Text(AutoSpotoConstants.Strings.LICENSE_IS_VALID)
                                    .font(.josefinSansRegular(18))
                                    .foregroundColor(Color.spotifyGreen)
                            } else if userEnteredInvalidLicense {
                                Text(AutoSpotoConstants.Strings.LICENSE_IS_INVALID)
                                    .font(.josefinSansRegular(18))
                                    .foregroundColor(Color.errorRed)
                            } else if let retrievedLicenseKey {
                                Text(AutoSpotoConstants.Strings.VALIDATING_LICENSE)
                                    .font(.josefinSansRegular(16))
                                    .onAppear {
                                        validateLicense(licenseKey: retrievedLicenseKey)
                                    }
                            } else {
                                Text(AutoSpotoConstants.Strings.FETCHING_LICENSE)
                                    .font(.josefinSansRegular(16))
                            }
                        }
                        
                    }
                }
                
                Divider()
                    .frame(height: 0.5)
                    .overlay(.gray)
                
                Spacer()
                
                HStack {
                    if !userPurchasedLicense {
                        NotNowButton(action: {
                            showCreatePlaylistSheet = false
                        })
                    }
                    
                    Spacer()
                    
                    if userPurchasedLicense {
                        DoneButton(action: {
                            withAnimation {
                                showCreatePlaylistSheet = false
                            }
                        })
                        .disabled(isValidatingLicense)
                    }
                }
            }
        }
        .frame(width: 700, height: 590)
        .padding(.all, 25)
        .padding(25)
        .disabled(isValidatingLicense)
    }
    
    private func validateLicense(licenseKey: String) {
        isValidatingLicense = true
        userEnteredInvalidLicense = false
        userEnteredValidLicense = false
        
        Task {
            let verify = await GumroadManager.verify(licenseKey: licenseKey, shouldIncrementUses: true)
            
            if verify {
                userEnteredValidLicense = true
            } else {
                userEnteredInvalidLicense = true
            }
            
            isValidatingLicense = false
        }
    }
}
