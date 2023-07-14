//
//  ChatTypeFilterToggle.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-14.
//

import SwiftUI

struct ChatTypeFilterToggle: View {
    let title: String
    
    @Binding var isEnabled: Bool
    
    var body: some View {
        Toggle(isOn: $isEnabled) { }
        .toggleStyle(ChatTypeFilterToggleStyle(title: title))
    }
}
