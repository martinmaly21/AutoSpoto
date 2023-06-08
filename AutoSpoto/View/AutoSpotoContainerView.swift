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
            //TODO: more fine grained checks. E.g. if user has granted disk access
            if KeychainManager.authenticationTokenExists {
                //user has previously logged in
                //we will assume Spotify profile exists too, since it's set at same time
                autoSpotoCurrentView = .home
            } else {
                //otherwise, show user onboarding
                autoSpotoCurrentView = .onboarding
            }
        }
    }
}

struct AutoSpotoContainerView_Previews: PreviewProvider {
    static var previews: some View {
        AutoSpotoContainerView()
    }
}
