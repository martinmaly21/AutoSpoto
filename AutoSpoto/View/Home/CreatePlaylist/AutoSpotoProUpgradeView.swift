//
//  AutoSpotoProUpgradeView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI

struct AutoSpotoProUpgradeView: View {
    @Binding var showCreatePlaylistSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(AutoSpotoConstants.Strings.UPGRADE_TO_AUTOSPOTO_PRO_TITLE)
                .font(.josefinSansBold(22))
                .font(.headline)
                
            Text(AutoSpotoConstants.Strings.UPGRADE_TO_AUTOSPOTO_PRO_SUBTITLE)
                .font(.josefinSansRegular(16))
                .padding(.bottom, 15)
            
            Divider()
                .frame(height: 0.5)
                .overlay(.gray)
            
            HStack(spacing: 0) {
                Image("OnboardingAppIcon")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .offset(x: -10)
                
                VStack(alignment: .leading) {
                    Text(AutoSpotoConstants.Strings.AUTOSPOTO_PRO_PRODUCT_TITLE)
                        .font(.josefinSansBold(20))
                        .font(.headline)
                        
                    Text(AutoSpotoConstants.Strings.AUTOSPOTO_PRO_PRODUCT_SUBTITLE)
                        .font(.josefinSansRegular(18))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(AutoSpotoConstants.Strings.AUTOSPOTO_PRO_PRODUCT_BUY_NOW)
                        .font(.josefinSansRegular(14))
                        
                    Text(AutoSpotoConstants.Strings.AUTOSPOTO_PRO_PRODUCT_PRICE)
                        .font(.josefinSansBold(20))
                }
            }
            
            Divider()
                .frame(height: 0.5)
                .overlay(.gray)
            
            Spacer()
            
            HStack {
                NotNowButton(action: {
                    showCreatePlaylistSheet = false
                })
                
                Spacer()
                
                ActivateLicenseButton(action: {
                    
                })
                
                BuyNowButton(action: {
                    
                })
            }
        }
        .frame(width: 700, height: 400)
        .padding(.all, 25)
        .padding(25)
    }
}
