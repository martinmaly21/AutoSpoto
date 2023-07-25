//
//  HTTPManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import Foundation

class HTTPManager {
    public static func validStatusCode(_ statusCode: Int) -> Bool {
        switch statusCode {
        case AutoSpotoConstants.HTTPStatus.ok,
            AutoSpotoConstants.HTTPStatus.created,
            AutoSpotoConstants.HTTPStatus.accepted,
            AutoSpotoConstants.HTTPStatus.noContent,
            AutoSpotoConstants.HTTPStatus.movedPermanently,
            AutoSpotoConstants.HTTPStatus.found,
            AutoSpotoConstants.HTTPStatus.movedTemporarily,
            AutoSpotoConstants.HTTPStatus.temporaryRedirect,
            AutoSpotoConstants.HTTPStatus.permanentRedirect:
            return true
        default:
            return false
        }
    }
}
