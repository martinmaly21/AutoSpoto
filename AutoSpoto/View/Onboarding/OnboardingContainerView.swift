//
//  ContentView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

struct OnboardingContainerView: View {
    @Binding var autoSpotoCurrentView: AutoSpotoContainerView.CurrentView

    enum CurrentView {
        case getStarted
        case diskAccessIntroductionView
        case chooseMusicStreamingServiceView
    }
    @State private var onboardingCurrentView: CurrentView = .getStarted

    //title animation parameter
    @State private var topLeftLogoOpacity: CGFloat = 0

    @State private var shouldAnimateLogoToTopLeft = false
    @State private var elementTransitionOpacity: CGFloat = 1.0

    @State private var spotifyAccessToken: String?

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
                ChooseMusicStreamingServiceView(spotifyAccessToken: $spotifyAccessToken)
            }

            let shouldHideToolBar = onboardingCurrentView == .chooseMusicStreamingServiceView && spotifyAccessToken == nil
            //tool bar
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(
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
                                withAnimation {
                                    autoSpotoCurrentView = .home
                                }
                            }
                        },
                        label: {
                            Text(onboardingCurrentView == .chooseMusicStreamingServiceView ? AutoSpotoConstants.Strings.FINISH : AutoSpotoConstants.Strings.CONTINUE)
                                .font(.josefinSansRegular(18))
                        }
                    )
                    .customButton(foregroundColor: .backgroundPrimary, backgroundColor: .textPrimary)
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
        .background(
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
        )
    }
}
