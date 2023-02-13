//
//  String.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import Foundation

extension String {
    func getQueryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: self) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
