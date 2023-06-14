//
//  SyncButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-11.
//

import SwiftUI

struct SyncButton: View {
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
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}
