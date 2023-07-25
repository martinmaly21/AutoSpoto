//
//  AutoSpotoProUpgradeView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI

struct AutoSpotoProUpgradeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
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
                
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(AutoSpotoConstants.Strings.LICENSE_KEY)
                        .font(.josefinSansRegular(18))
                    
                    TextField(AutoSpotoConstants.Strings.LICENSE_KEY_PLACEHOLDER, text: $licenseKey)
                        .font(.josefinSansRegular(18))
                        .disabled(userEnteredValidLicense)
                    
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
                                showCreatePlaylistSheet = false
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
                    .opacity(userPurchasedLicense ? 0 : 1)
                    
                Text(AutoSpotoConstants.Strings.UPGRADE_TO_AUTOSPOTO_PRO_SUBTITLE)
                    .font(.josefinSansRegular(16))
                    .padding(.bottom, 15)
                    .frame(height: 60)
                    .opacity(userPurchasedLicense ? 0 : 1)
                
                Divider()
                    .frame(height: 0.5)
                    .overlay(.gray)
                    .opacity(userPurchasedLicense ? 0 : 1)
                
                ZStack {
                    UpgradeToAutoSpotoProWebView(
                        isLoadingWebView: $isLoadingWebView,
                        retrievedLicenseKey: $retrievedLicenseKey,
                        userPurchasedLicense: $userPurchasedLicense
                    )
                    .opacity(userPurchasedLicense ? 0 : 1)
                    
                    if isLoadingWebView {
                        ProgressView()
                    }
                    
                    if userPurchasedLicense {
                        VStack(spacing: 6) {
                            if userEnteredValidLicense {
                                ZStack(alignment: .center) {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .background(Color.white)
                                    
                                    Image(systemName: "checkmark.seal.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(Color.spotifyGreen)
                                }
                                
                                Text(AutoSpotoConstants.Strings.LICENSE_IS_VALID)
                                    .font(.josefinSansRegular(18))
                                    .padding(.top, 10)
                            } else if userEnteredInvalidLicense {
                                ZStack(alignment: .center) {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .background(Color.white)
                                    
                                    Image(systemName: "xmark.seal.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(Color.errorRed)
                                }
                                
                                Text(AutoSpotoConstants.Strings.LICENSE_IS_INVALID_FROM_PURCHASE)
                                    .font(.josefinSansRegular(18))
                                
                                EnterLicenseButton(
                                    action: {
                                        withAnimation {
                                            self.userEnteredInvalidLicense = false
                                            self.userAlreadyHasLicense = true
                                        }
                                    }
                                )
                                .padding(.top, 10)
                            } else if let retrievedLicenseKey {
                                ProgressView()
                                
                                Text(AutoSpotoConstants.Strings.VALIDATING_LICENSE)
                                    .font(.josefinSansRegular(16))
                                    .onAppear {
                                        validateLicense(licenseKey: retrievedLicenseKey)
                                    }
                            } else {
                                ProgressView()
                                
                                Text(AutoSpotoConstants.Strings.FETCHING_LICENSE)
                                    .font(.josefinSansRegular(16))
                            }
                        }
                        
                    }
                }
                
                Divider()
                    .frame(height: 0.5)
                    .overlay(.gray)
                    .opacity(userPurchasedLicense ? 0 : 1)
                
                Spacer()
                
                HStack {
                    if !userPurchasedLicense {
                        NotNowButton(action: {
                            showCreatePlaylistSheet = false
                        })
                    }
                    
                    Spacer()
                    
                    if userPurchasedLicense {
                        if userEnteredValidLicense {
                            DoneButton(action: {
                                withAnimation {
                                    showCreatePlaylistSheet = false
                                }
                            })
                            .disabled(isValidatingLicense)
                        }
                    } else {
                        AlreadyHaveALicenseButton(
                            action: {
                                withAnimation {
                                    self.userAlreadyHasLicense = true
                                }
                            }
                        )
                    }
                }
            }
        }
        .frame(width: 700, height: 700)
        .padding(.all, 25)
        .padding(25)
        .disabled(isValidatingLicense)
    }
    
    private func validateLicense(licenseKey: String) {
        isValidatingLicense = true
        userEnteredInvalidLicense = false
        userEnteredValidLicense = false
        
        Task {
            let verify = await GumroadManager.verify(licenseKey: licenseKey)
            
            if verify {
                homeViewModel.isAutoSpotoPro = true
                userEnteredValidLicense = true
            } else {
                userEnteredInvalidLicense = true
            }
            
            isValidatingLicense = false
        }
    }
}
