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


        }
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
    }
}
