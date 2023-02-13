//
//  AutoSpotoContainerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-13.
//

import SwiftUI

struct AutoSpotoContainerView: View {
    enum CurrentView {
        case onboarding
        case home
    }
    @State private var autoSpotoCurrentView: CurrentView = .onboarding
    
    var body: some View {
        ZStack {
            switch autoSpotoCurrentView {
            case .onboarding:
                OnboardingContainerView(autoSpotoCurrentView: $autoSpotoCurrentView)
            case .home:
                HomeContainerView()
            }
        }
        .onAppear {
            //TODO: check if user has went through "Onboarding" process

            //TODO: check if user has granted disk access. if so:

            //IF so, check if user has logged in to streaming service
            //if yes, bring them to main app screen

            //IF not, show stream service shit

            //if no disk access, show them splash screen again


            //IF so, show messages UI
            //If not, show OnboardingContainerView
            autoSpotoCurrentView = .onboarding
        }
    }
}

struct AutoSpotoContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AutoSpotoContainerView()
    }
}
