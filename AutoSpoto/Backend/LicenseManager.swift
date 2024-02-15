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
        do {
            guard let licenseURL = DiskAccessManager.licenseURL else {
                return false
            }
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
        
        do {
            if let licenseURL = DiskAccessManager.licenseURL {
                try encryptedData.write(to: licenseURL)
            }
        } catch {
            fatalError("Error encrypting: \(error.localizedDescription)")
        }
    }
    
    public static func deleteLicense() {
        do {
            if let licenseURL = DiskAccessManager.licenseURL {
                try FileManager.default.removeItem(at: licenseURL)
            }
        } catch let error {
            print("Error deleting license: \(error.localizedDescription)")
        }
    }
}
