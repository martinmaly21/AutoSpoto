//
//  ChatType.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import Foundation

enum ChatType: Hashable {
    case individual(firstName: String?, lastName: String?)
    case group(name: String?)
}
