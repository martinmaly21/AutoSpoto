//
//  WhatIsAutoSpotoView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-31.
//

import SwiftUI

struct WhatIsAutoSpotoView: View {
    @State private var elementTransitionOpacity: CGFloat = 0
    
    var body: some View {
        VStack {
            Text(AutoSpotoConstants.Strings.WHAT_IS_AUTOSPOTO)
                .font(.josefinSansSemibold(60))
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
