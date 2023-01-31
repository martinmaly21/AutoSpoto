//
//  GetStartedView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct GetStartedView: View {
    @Binding var currentView: OnboardingContainerView.CurrentView

    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                    .font(.josefinSansBold(90))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text(AutoSpotoConstants.Strings.AUTO_SPOTO_SPLASH_MOTTO)
                    .font(.josefinSansRegular(30))
                    .foregroundColor(.white)
                    .padding(.bottom, 120)

                Button(
                    action: {
                        currentView = .howDoesItWork
                    },
                    label: {
                        Text(AutoSpotoConstants.Strings.GET_STARTED)
                            .font(.josefinSansRegular(18))
                    }
                )
                .customButton(foregroundColor: .black, backgroundColor: .white)
            }

            VStack {
                Spacer()
                Text(AutoSpotoConstants.Strings.MADE_WITH_LOVE)
                    .foregroundColor(.white)
                    .font(.josefinSansRegular(15))
            }
        }
    }
}
