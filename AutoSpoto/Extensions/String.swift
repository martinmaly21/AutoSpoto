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

    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }

    //retrieved from: https://stackoverflow.com/a/47671579
    func capturedGroups(withRegex pattern: String) -> [String] {
        var results = [String]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))

        guard let match = matches.first else { return results }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }

        return results
    }
}
