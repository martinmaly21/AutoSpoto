//
//  BuyNowButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI

struct BuyNowButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(AutoSpotoConstants.Strings.AUTOSPOTO_PRO_PRODUCT_BUY_NOW)
                    .font(.josefinSansRegular(18))
                    .frame(width: 100, height: 30)
                    .background(Color.primaryBlue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}

