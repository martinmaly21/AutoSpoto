//
//  DiskAccessManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-14.
//

import Foundation

class DiskAccessManager {
    public static var userAuthorizedDiskAccess: Bool {
        //determine disk access by checking whether we can access chat.db
        return (try? FileManager.default.contentsOfDirectory(atPath: "\(NSHomeDirectory())/Library/Messages")) != nil
    }
}
