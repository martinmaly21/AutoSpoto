//
//  UpgradeToProButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-12.
//

import SwiftUI

struct UpgradeToProButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(AutoSpotoConstants.Strings.UPGRADE_TO_PRO)
                    .font(.josefinSansBold(14))
                    .padding(6)
                    .padding(.horizontal, 8)
                    .background(Color.primaryBlue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}
