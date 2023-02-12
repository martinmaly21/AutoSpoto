//
//  FilterChatType.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import Foundation

enum FilterChatType {
    case individual
    case group

    var localizedString: String {
        switch self {
        case .individual:
            return AutoSpotoConstants.Strings.INDIVIDUAL_PICKER_OPTION
        case .group:
            return AutoSpotoConstants.Strings.GROUP_PICKER_OPTION
        }
    }
}
