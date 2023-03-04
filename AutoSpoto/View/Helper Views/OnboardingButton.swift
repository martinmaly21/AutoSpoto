//
//  OnboardingButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-03-04.
//

import SwiftUI

struct OnboardingButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(title)
                    .font(.josefinSansSemibold(18))
                    .frame(height: 40)
                    .padding(.horizontal, 30)
                    .background(Color.onboardingNavigationButtonBackgroundColor)
                    .foregroundColor(Color.onboardingNavigationButtonTextColor)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}
