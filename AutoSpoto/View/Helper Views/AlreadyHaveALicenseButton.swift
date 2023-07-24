//
//  AlreadyHaveALicenseButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI

struct AlreadyHaveALicenseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(AutoSpotoConstants.Strings.ALREADY_HAVE_A_LICENSE)
                    .font(.josefinSansRegular(18))
                    .frame(width: 215, height: 30)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}
