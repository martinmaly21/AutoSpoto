//
//  View.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-28.
//

import SwiftUI

extension View {
  func customButton(
    foregroundColor: Color = .white,
    backgroundColor: Color = .gray,
    pressedColor: Color = .accentColor
  ) -> some View {
    self.buttonStyle(
      CustomButtonStyle(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        pressedColor: pressedColor
      )
    )
  }
}
