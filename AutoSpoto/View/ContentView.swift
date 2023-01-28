//
//  ContentView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2022-09-03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text(AutoSpotoConstants.Strings.AUTO_SPOTO_APP_NAME)
                .font(.graphikBlackItalic(90))

            Button(
                action: {
                    //TODO
                },
                label: {
                    Text(AutoSpotoConstants.Strings.GET_STARTED)
                        .font(.graphikBlackItalic(20))
                }
            )
        }
        .padding()
        .frame(width: 1000, height: 600)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.primaryBlue,
                        Color.tertiaryBlue
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottom
            )
        )

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
