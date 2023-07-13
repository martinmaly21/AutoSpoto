//
//  PersonPictureView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-03-04.
//

import SwiftUI

struct PersonPictureView: View {
    let base64ImageData: Data?
    let dimension: CGFloat
    let isSelected: Bool
    let isGroupChat: Bool

    var body: some View {
        ZStack {
            if let base64ImageData = base64ImageData,
               let nsImage = NSImage(data: base64ImageData) {
                Image(nsImage: nsImage)
                    .resizable()
            } else {
                Image(systemName: isGroupChat ? "person.2.circle" : "person.circle")
                    .resizable()
                    .foregroundColor(isSelected ? Color.selectedPersonPictureTintColor : Color.unselectedPersonPictureTintColor)
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: dimension, height: dimension)
        .background(Color.clear)
        .clipShape(Circle())
    }
}
