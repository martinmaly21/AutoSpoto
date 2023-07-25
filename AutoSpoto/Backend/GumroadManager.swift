//
//  GumroadManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import Foundation

class GumroadManager {
    public static func verify(licenseKey: String) async -> Bool {
        var request = URLRequest(url: AutoSpotoConstants.URL.gumroadAPIEndpoint)
        request.httpMethod = "POST"
        
        let params = "\(AutoSpotoConstants.HTTPParameter.product_id)=\(AutoSpotoConstants.Gumroad.autoSpotoProProductID)&\(AutoSpotoConstants.HTTPParameter.license_key)=\(licenseKey)"
        request.httpBody = params.data(using: .utf8)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  HTTPManager.validStatusCode(httpURLResponse.statusCode) else {
                print("‼️ ERROR: \(String(decoding: data, as: UTF8.self))")
                throw AutoSpotoError.unexpectedHTTPUrlResponse
            }
            
            let gumroadVerification = try JSONDecoder().decode(GumroadVerification.self, from: data)
            
            let isVerified = gumroadVerification.success &&
            gumroadVerification.uses <= 1 &&
            gumroadVerification.purchase.product_id == AutoSpotoConstants.Gumroad.autoSpotoProProductID &&
            !gumroadVerification.purchase.refunded &&
            !(gumroadVerification.purchase.disputed && gumroadVerification.purchase.dispute_won) &&
            !gumroadVerification.purchase.chargebacked
            
            //update license file on users system to indicate they are now verified
            LicenseManager.writeLicense()
            
            return isVerified
        } catch let error {
            print("😭 ERROR: \(error)")
            return false
        }
    }
}
