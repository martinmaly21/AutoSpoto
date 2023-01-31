//
//  ContentView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

struct OnboardingContainerView: View {
    enum CurrentView {
        case getStarted
        case whatIsAutoSpoto
    }
    @State private var currentView: CurrentView = .getStarted

    //title animation parameter
    @State private var topLeftLogoOpacity: CGFloat = 0

    private let defaultHorizontalPadding: CGFloat = 16.5
    private let defaultBottomPadding: CGFloat = 10

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                        .font(.josefinSansBold(30))
                        .foregroundColor(.white)
                        .padding(.leading, 18)
                        .opacity(topLeftLogoOpacity)

                    Spacer()
                }

                Spacer()
            }

            switch currentView {
            case .getStarted:
                GetStartedView(
                    currentView: $currentView,
                    topLeftLogoOpacity: $topLeftLogoOpacity
                )
            case .whatIsAutoSpoto:
                WhatIsAutoSpotoView(currentView: $currentView)
            }

            //Made with LOVE footer
            VStack {
                Spacer()
                Text(AutoSpotoConstants.Strings.MADE_WITH_LOVE)
                    .foregroundColor(.white)
                    .font(.josefinSansRegular(15))
            }

            //tool bar
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(
                        action: {
                            //todo
                        },
                        label: {
                            Text(AutoSpotoConstants.Strings.CONTINUE)
                                .font(.josefinSansRegular(18))
                        }
                    )
                    .customButton(foregroundColor: .black, backgroundColor: .white)
                    .padding(.trailing, defaultHorizontalPadding)
                }
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .padding(.horizontal, -defaultHorizontalPadding)
                .padding(.bottom, -defaultBottomPadding)
            }
            .opacity(topLeftLogoOpacity)

        }
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
                        Color.black
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottom
            )
        )
    }
}
