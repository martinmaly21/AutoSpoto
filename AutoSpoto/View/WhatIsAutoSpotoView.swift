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
            Image("GenericFolderIcon")
                .resizable()
                .frame(width: 200, height: 200)

            Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_TITLE)
                .font(.josefinSansSemibold(30))
                .foregroundColor(.white)
                .padding(.bottom, 10)

            Text(AutoSpotoConstants.Strings.FULL_DISK_ACCESS_PERMISSION_SUBTITLE)
                .font(.josefinSansLight(18))
                .foregroundColor(.white)
                .padding(.bottom, 10)

            Button(
                action: {
                    NSWorkspace.shared.open(AutoSpotoConstants.URL.fullDiskAccess)
                },
                label: {
                    Text(AutoSpotoConstants.Strings.OPEN_SETTINGS)
                        .font(.josefinSansRegular(18))
                }
            )
            .customButton(foregroundColor: .black, backgroundColor: .white)
        }
        .opacity(elementTransitionOpacity)
        .onAppear {
            withAnimation {
                elementTransitionOpacity = 1
            }
        }
    }
}
