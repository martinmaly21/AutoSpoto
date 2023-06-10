//
//  Array.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-09.
//

import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
    
    func splitIntoChunks(of maxLength: Int) -> [[Element]] {
        var result = [[Element]]()
        var temporaryStorageArray: [Element] = []
        
        //split track IDs in chunks of 'numberOfTrackMetadataPerFetch'
        for value in self {
            temporaryStorageArray.append(value)
            if temporaryStorageArray.count == maxLength {
                result.append(temporaryStorageArray)
                temporaryStorageArray.removeAll()
            }
        }
        if !temporaryStorageArray.isEmpty {
            result.append(temporaryStorageArray)
        }

        return result
    }
}
