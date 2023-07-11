//
//  ContactRow.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-07.
//

import Foundation

struct ContactRow: Equatable {
    let firstName: String?
    let lastName: String?
    let contactInfo: String
    let imageBlob: String?

    static func ==(lhs: ContactRow, rhs: ContactRow) -> Bool {
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.contactInfo == rhs.contactInfo &&
            lhs.imageBlob == rhs.imageBlob
    }
}
