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
        case howDoesItWork
    }
    @State private var currentView: CurrentView = .getStarted

    //title animation parameter
    @State private var topLeftLogoOpacity: CGFloat = 0

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
            case .howDoesItWork:
                HowDoesItWorkView(currentView: $currentView)
            }

            //Made with LOVE footer
            VStack {
                Spacer()
                Text(AutoSpotoConstants.Strings.MADE_WITH_LOVE)
                    .foregroundColor(.white)
                    .font(.josefinSansRegular(15))
            }

            //TODO: add tool bar
        }
        .padding(.horizontal, 16.5)
        .padding(.vertical, 10)
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
