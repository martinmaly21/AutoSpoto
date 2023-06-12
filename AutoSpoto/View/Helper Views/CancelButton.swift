//
//  CancelButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-12.
//

import SwiftUI

struct CancelButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(AutoSpotoConstants.Strings.CANCEL)
                    .font(.josefinSansRegular(18))
                    .frame(width: 100, height: 30)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}
