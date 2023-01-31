//
//  WhatIsAutoSpotoView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct WhatIsAutoSpotoView: View {
    @Binding var currentView: OnboardingContainerView.CurrentView

    @State private var elementTransitionOpacity: CGFloat = 0
    
    var body: some View {
        VStack {
            Text(AutoSpotoConstants.Strings.WHAT_IS_AUTOSPOTO)
                .font(.josefinSansSemibold(60))
                .foregroundColor(.white)
                .padding(.bottom, 120)
                .opacity(elementTransitionOpacity)

//            Divider()

            Text(AutoSpotoConstants.Strings.WHAT_IS_AUTOSPOTO_ANSWER)
                .font(.josefinSansRegular(18))
                .foregroundColor(.white)
                .padding(.bottom, 120)
                .opacity(elementTransitionOpacity)
        }
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
    }
}
