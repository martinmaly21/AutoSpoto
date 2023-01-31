//
//  ContentView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

struct AppEntryView: View {
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                    .font(.josefinSansBold(90))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text(AutoSpotoConstants.Strings.AUTO_SPOTO_SPLASH_MOTTO)
                    .font(.josefinSansRegular(30))
                    .foregroundColor(.white)
                    .padding(.bottom, 120)

                Button(
                    action: {
                        //TODO
                    },
                    label: {
                        Text(AutoSpotoConstants.Strings.GET_STARTED)
                            .font(.josefinSansRegular(16))
                    }
                )
                .customButton(foregroundColor: .black, backgroundColor: .white)
            }

            VStack {
                Spacer()
                Text(AutoSpotoConstants.Strings.MADE_WITH_LOVE)
                    .foregroundColor(.white)
                    .font(.josefinSansRegular(15))
            }
        }
        .padding()
        .frame(width: 1000, height: 600)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.primaryBlue,
                        Color.black
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottom
            )
        )
    }
}
