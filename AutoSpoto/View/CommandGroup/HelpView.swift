//
//  HelpView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2024-02-29.
//

import SwiftUI
import AppKit

struct HelpView: View {
    @Binding var isOpen: Bool

    var body: some View {
        VStack {
            
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(AutoSpotoConstants.Strings.CONTACT_AUTOSPOTO)
                            .font(.josefinSansSemibold(32))
                            .foregroundColor(.textPrimaryWhite)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 16)
                            .padding(.top, 25)
                            .padding(.bottom, 20)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .top) {
                            Text(AutoSpotoConstants.Strings.CONTACT_US_BODY)
                                .font(.josefinSansRegular(18))
                                .padding(.top, 8)
                            
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        
                        ContactUsButton {
                            //
                            let service = NSSharingService(named: NSSharingService.Name.composeEmail)

                            service?.recipients = ["autospoto.official@gmail.com"]
                            service?.subject = "AutoSpoto - User Contact Form"
                            service?.perform(withItems: [""])
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .background(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.regularMaterial, lineWidth: 2)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
            .frame(width: 1000, height: 250)
        }
        .onDisappear {
            isOpen = false
        }
        .onAppear {
            isOpen = true
        }
    }
}


