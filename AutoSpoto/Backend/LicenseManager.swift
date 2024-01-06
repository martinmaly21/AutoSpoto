//
//  LicenseManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import Foundation
import RNCryptor

class LicenseManager {
    //retrieved from https://stackoverflow.com/a/33845083
    private static var uniqueMachineID: String {
        // Get the platform expert
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
        
        // Get the serial number as a CFString ( actually as Unmanaged<AnyObject>! )
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0);
        
        // Release the platform expert (we're responsible)
        IOObjectRelease(platformExpert);
        
        // Take the unretained value of the unmanaged-any-object
        // (so we're not responsible for releasing it)
        // and pass it back as a String or, if it fails, an empty string
        return (serialNumberAsCFString?.takeUnretainedValue() as? String) ?? "UNKNOWN_SERIAL_NUMBER"
    }
    
    public static var userHasValidLicense: Bool {
        let fileManager = FileManager.default
        guard let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return false
        }
        
        do {
            let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto")
            try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            let licenseURL = directoryURL.appendingPathComponent("license.json")
            
            let data = try Data(contentsOf: licenseURL)
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
        
        let fileManager = FileManager.default
        if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            do {
                let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto")
                try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                let licenseURL = directoryURL.appendingPathComponent("license.json")
                
                try encryptedData.write(to: licenseURL)
            } catch {
                fatalError("Error encrypting: \(error.localizedDescription)")
            }
        }
    }
    
    public static func deleteLicense() {
        let fileManager = FileManager.default
        if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            do {
                let directoryURL = appSupportURL.appendingPathComponent("AutoSpoto")
                try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                let licenseURL = directoryURL.appendingPathComponent("license.json")
                
                try fileManager.removeItem(at: licenseURL)
            } catch let error {
                print("Error deleting license: \(error.localizedDescription)")
            }
        }
    }
}
