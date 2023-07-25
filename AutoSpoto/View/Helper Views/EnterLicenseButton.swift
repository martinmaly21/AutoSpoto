//
//  EnterLicenseButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-25.
//

import Foundation

struct AlreadyHaveALicenseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(AutoSpotoConstants.Strings.ENTER_LICENSE)
                    .font(.josefinSansRegular(18))
                    .frame(width: 180, height: 30)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}
