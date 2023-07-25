//
//  LicenseManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import Foundation
import RNCryptor

class LicenseManager {
    private static var uniqueMachineID: String {
        return "testing"
    }
    
    public static var userHasValidLicense: Bool {
        guard let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return false
        }
        
        let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/license.json")
        
        do {
            let data = try Data(contentsOf: directoryURL)
            let encryptedData = try RNCryptor.decrypt(data: data, withPassword: lFile)
            guard let uniqueMachineID = String(data: encryptedData, encoding: .utf8) else {
                return false
            }
            
            return self.uniqueMachineID == uniqueMachineID
        } catch {
            return false
        }
    }
    
    public static func writeLicense() {
        let data = Data(uniqueMachineID.utf8)
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: lFile)
        
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/license.json")
            do {
                try encryptedData.write(to: directoryURL)
            } catch {
                fatalError("Error encrypting: \(error.localizedDescription)")
            }
        }
    }
}
