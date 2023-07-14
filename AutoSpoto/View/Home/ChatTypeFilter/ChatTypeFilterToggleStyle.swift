//
//  ChatTypeFilterToggleStyle.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-14.
//

import SwiftUI

struct ChatTypeFilterToggleStyle: ToggleStyle {
    let title: String
    
    func makeBody(configuration: Configuration) -> some View {
        Text(title)
            .frame(height: 27.5)
            .frame(maxWidth: .infinity)
            .font(.josefinSansBold(14))
            .background(configuration.isOn ? Color.spotifyGreen : Color.clear)
            .foregroundColor(configuration.isOn ? Color.white : Color.white)
            .clipShape(Capsule())
            .contentShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(configuration.isOn ? Color.spotifyGreen : Color.white, lineWidth: 1)
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    configuration.isOn.toggle()
                }
            }
    }
}
