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

    var body: some View {
        VStack {
            switch currentView {
            case .getStarted:
                GetStartedView(currentView: $currentView)
            case .howDoesItWork:
                HowDoesItWorkView(currentView: $currentView)
            }
        }
        .padding()
        .frame(width: 1000, height: 600)
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
