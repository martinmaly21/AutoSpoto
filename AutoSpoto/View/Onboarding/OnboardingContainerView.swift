//
//  ContentView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

struct OnboardingContainerView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var autoSpotoCurrentView: AutoSpotoContainerView.CurrentView
    
    enum CurrentView {
        case getStarted
        case permissionsRequestView
    }
    @State private var onboardingCurrentView: CurrentView = .getStarted
    @State var userAuthorizedDiskAccess: Bool = false
    @State var userAuthorizedSpotify: Bool = false
    
    enum OnboardingGradient {
        case lightMode, darkMode
        
        @ViewBuilder
        var shape: some View {
            switch self {
            case .lightMode:
                RadialGradient(
                    gradient: Gradient(
                        colors: [
                            Color.backgroundPrimary,
                            Color.backgroundSecondary,
                        ]
                    ),
                    center: .topTrailing,
                    startRadius: 0,
                    endRadius: 600
                )
            case .darkMode:
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.backgroundPrimary,
                            Color.backgroundSecondary
                        ]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottom
                )
            }
        }
    }
    
    //title animation parameter
    @State private var topLeftLogoOpacity: CGFloat = 0
    
    @State private var shouldAnimateLogoToTopLeft = false
    @State private var elementTransitionOpacity: CGFloat = 1.0
    
    private let defaultHorizontalPadding: CGFloat = 16.5
    private let defaultBottomPadding: CGFloat = 10
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                        .font(.josefinSansBold(30))
                        .foregroundColor(.textPrimaryWhite)
                        .padding(.leading, 18)
                        .padding(.top, 18)
                        .opacity(topLeftLogoOpacity)
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            switch onboardingCurrentView {
            case .getStarted:
                GetStartedView(
                    onboardingCurrentView: $onboardingCurrentView,
                    topLeftLogoOpacity: $topLeftLogoOpacity,
                    shouldAnimateLogoToTopLeft: $shouldAnimateLogoToTopLeft,
                    elementTransitionOpacity: $elementTransitionOpacity
                )
            case .permissionsRequestView:
                PermissionsRequestView(
                    userAuthorizedSpotify: $userAuthorizedSpotify,
                    userAuthorizedDiskAccess: $userAuthorizedDiskAccess
                )
            }
            
            let shouldDisableToolBar = onboardingCurrentView == .permissionsRequestView && (!userAuthorizedSpotify || !userAuthorizedDiskAccess)
            //tool bar
            VStack {
                Spacer()
                
                HStack {
                    
                    OnboardingButton(
                        title: onboardingCurrentView == .permissionsRequestView ? AutoSpotoConstants.Strings.FINISH : AutoSpotoConstants.Strings.CONTINUE,
                        action: {
                            switch onboardingCurrentView {
                            case .getStarted:
                                userAuthorizedDiskAccess = DiskAccessManager.userAuthorizedDiskAccess
                                userAuthorizedSpotify = SpotifyTokenManager.authenticationTokenExists
                                
                                withAnimation {
                                    shouldAnimateLogoToTopLeft = true
                                    elementTransitionOpacity = 0
                                }
                            case .permissionsRequestView:
                                withAnimation {
                                    autoSpotoCurrentView = .home
                                }
                            }
                            
                        },
                        width: 150,
                        height: 35
                    )
                    .padding(.trailing, defaultHorizontalPadding)
                    .padding(.bottom, 20)
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, -defaultHorizontalPadding)
                .padding(.bottom, -defaultBottomPadding)
            }
            .disabled(shouldDisableToolBar)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, defaultHorizontalPadding)
        .padding(.bottom, defaultBottomPadding)
        .frame(
            width: AutoSpotoConstants.Dimensions.onboardingWindowWidth,
            height: AutoSpotoConstants.Dimensions.onboardingWindowHeight
        )
        .background(colorScheme == .light ? OnboardingGradient.lightMode.shape : OnboardingGradient.darkMode.shape)
    }
}
