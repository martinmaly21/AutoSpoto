//
//  ChatTypeFilter.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-14.
//

import SwiftUI

struct ChatTypeFilter: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            ChatTypeFilterToggle(
                title: AutoSpotoConstants.Strings.INDIVIDUAL,
                isEnabled: $homeViewModel.isFilteringIndividualChat
            )
            ChatTypeFilterToggle(
                title: AutoSpotoConstants.Strings.GROUP,
                isEnabled: $homeViewModel.isFilteringGroupChat
            )
            
            Spacer()
        }
        .padding(.leading, 14)
        .disabled(homeViewModel.isFetchingChats)
    }
}
