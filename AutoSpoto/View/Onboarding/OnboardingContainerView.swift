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
        case diskAccessIntroductionView
        case chooseMusicStreamingServiceView
        case accessContactsView
    }
    @State private var onboardingCurrentView: CurrentView = .getStarted

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
                            Color.primaryBlue,
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
                            Color.primaryBlue,
                            Color.backgroundPrimary
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
            case .diskAccessIntroductionView:
                DiskAccessIntroductionView()
            case .chooseMusicStreamingServiceView:
                ChooseMusicStreamingServiceView()
            case .accessContactsView:
                AccessContactsView()
            }

            let shouldHideToolBar = onboardingCurrentView == .chooseMusicStreamingServiceView && KeychainManager.authenticationTokenExists
            //tool bar
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    OnboardingButton(
                        title: onboardingCurrentView == .accessContactsView ? AutoSpotoConstants.Strings.FINISH : AutoSpotoConstants.Strings.CONTINUE,
                        action: {
                            switch onboardingCurrentView {
                            case .getStarted:
                                withAnimation {
                                    shouldAnimateLogoToTopLeft = true
                                    elementTransitionOpacity = 0
                                }
                            case .diskAccessIntroductionView:
                                onboardingCurrentView = .chooseMusicStreamingServiceView
                            case .chooseMusicStreamingServiceView:
                                onboardingCurrentView = .accessContactsView
                            case .accessContactsView:
                                withAnimation {
                                    autoSpotoCurrentView = .home
                                }
                            }
                            
                        }
                    )
                    .padding(.trailing, defaultHorizontalPadding)
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .padding(.horizontal, -defaultHorizontalPadding)
                .padding(.bottom, -defaultBottomPadding)
            }
            .opacity(shouldHideToolBar ? 0 : 1)
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
