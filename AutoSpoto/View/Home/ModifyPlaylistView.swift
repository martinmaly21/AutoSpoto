//
//  ModifyPlaylistView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-11.
//

import SwiftUI

struct ModifyPlaylistView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showModifyPlaylistSheet: Bool
    
    let chat: Chat
    
    init(
        showModifyPlaylistSheet: Binding<Bool>,
        chat: Chat
    ) {
        self._showModifyPlaylistSheet = showModifyPlaylistSheet
        self.chat = chat
    }
    
    var body: some View {
        Text("THELE")
    }
}
