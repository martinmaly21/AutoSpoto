//
//  PersonPictureView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-03-04.
//

import SwiftUI

struct PersonPictureView: View {
    let base64ImageString: String?
    let dimension: CGFloat

    var body: some View {
        ZStack {
            if let base64ImageString = base64ImageString,
               let base64ImageStringData = Data(base64Encoded: base64ImageString),
               let nsImage = NSImage(data: base64ImageStringData) {
                Image(nsImage: nsImage)
                    .resizable()
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: dimension, height: dimension)
        .background(Color.gray)
        .clipShape(Circle())
    }
}
