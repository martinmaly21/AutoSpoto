//
//  LicenseManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import Foundation
import RNCryptor

class LicenseManager {
    public var licenseKey: String? {
        guard let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto/license.json")
        
        do {
            let data = try Data(contentsOf: directoryURL)
            let encryptedData = try RNCryptor.decrypt(data: data, withPassword: lFile)
            guard let licenseKey = String(data: encryptedData, encoding: .utf8) else {
                return nil
            }
            
            return licenseKey
        } catch {
            return nil
        }
    }
    
    public func writeLicense(licenseKey: String) {
        let data = Data(licenseKey.utf8)
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
