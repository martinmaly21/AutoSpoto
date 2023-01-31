//
//  GetStartedView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct GetStartedView: View {
    @Binding var currentView: OnboardingContainerView.CurrentView

    //animation parameters
    @Binding var topLeftLogoOpacity: CGFloat

    @Binding var shouldAnimateLogoToTopLeft: Bool
    @Binding var elementTransitionOpacity: CGFloat

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                        .font(.josefinSansBold(shouldAnimateLogoToTopLeft ? 30 : 90))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                        .padding(.leading, shouldAnimateLogoToTopLeft ? 18 : 0)

                    if shouldAnimateLogoToTopLeft {
                        Spacer()
                    }
                }

                if shouldAnimateLogoToTopLeft {
                    Spacer()
                }
            }

            Text(AutoSpotoConstants.Strings.AUTO_SPOTO_SPLASH_MOTTO)
                .font(.josefinSansRegular(30))
                .foregroundColor(.white)
                .padding(.bottom, 40)
                .opacity(elementTransitionOpacity)

            Divider()
                .overlay(.white)
                .padding(.bottom, 40)
                .opacity(elementTransitionOpacity)

            Text(AutoSpotoConstants.Strings.WHAT_IS_AUTOSPOTO_ANSWER)
                .font(.josefinSansRegular(18))
                .foregroundColor(.white)
                .padding(.bottom, 120)
                .padding(.horizontal, 35)
                .opacity(elementTransitionOpacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.red)
        .onAnimationCompleted(
            for: elementTransitionOpacity,
            completion: {
                topLeftLogoOpacity = 1
                currentView = .whatIsAutoSpoto
            }
        )
    }
}
