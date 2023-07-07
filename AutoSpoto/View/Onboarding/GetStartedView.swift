//
//  GetStartedView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct GetStartedView: View {
    @Binding var onboardingCurrentView: OnboardingContainerView.CurrentView

    //animation parameters
    @Binding var topLeftLogoOpacity: CGFloat

    @Binding var shouldAnimateLogoToTopLeft: Bool
    @Binding var elementTransitionOpacity: CGFloat

    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 8) {
                
                Image("autospoto-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 130)
                    .opacity(elementTransitionOpacity)
                
                HStack {
                    Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                        .font(.josefinSansBold(shouldAnimateLogoToTopLeft ? 30 : 60))
                        .foregroundColor(.textPrimaryWhite)
                        .padding(.bottom, 10)
                        .padding(.leading, shouldAnimateLogoToTopLeft ? 18 : 0)
                        .padding(.top, shouldAnimateLogoToTopLeft ? -160 : 0)

                    if shouldAnimateLogoToTopLeft {
                        Spacer()
                    }
                }

                if shouldAnimateLogoToTopLeft {
                    Spacer()
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 10)
            
            Divider()
                .frame(height: 0.5)
                .overlay(.gray)
                .padding(.bottom, 20)
                .opacity(elementTransitionOpacity)
            
            Text(AutoSpotoConstants.Strings.AUTO_SPOTO_SPLASH_MOTTO)
                .font(.josefinSansRegular(30))
                .foregroundColor(.textPrimaryWhite)
                .opacity(elementTransitionOpacity)


            Text(AutoSpotoConstants.Strings.WHAT_IS_AUTOSPOTO_ANSWER)
                .font(.josefinSansRegular(18))
                .foregroundColor(.textPrimaryWhite)
                .padding(.horizontal, 35)
                .padding(.bottom, 40)
                .opacity(elementTransitionOpacity)

//            Made with LOVE footer
            Text(AutoSpotoConstants.Strings.MADE_WITH_LOVE)
                .foregroundColor(.textPrimaryWhite)
                .font(.josefinSansRegular(14))
                .opacity(elementTransitionOpacity)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAnimationCompleted(
            for: elementTransitionOpacity,
            completion: {
                topLeftLogoOpacity = 1
                onboardingCurrentView = .permissionsRequestView
            }
        )
    }
}
