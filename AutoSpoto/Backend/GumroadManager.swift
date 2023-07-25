//
//  GumroadManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import Foundation

class GumroadManager {
    public static func verify(licenseKey: String, shouldIncrementUses: Bool) async -> Bool {
        var request = URLRequest(url: AutoSpotoConstants.URL.gumroadAPIEndpoint)
        request.httpMethod = "POST"
        
        let params: [String : Any] = [
            AutoSpotoConstants.HTTPParameter.product_id: AutoSpotoConstants.Gumroad.autoSpotoProProductID,
            AutoSpotoConstants.HTTPParameter.license_key: licenseKey,
            AutoSpotoConstants.HTTPParameter.increment_uses_count: shouldIncrementUses
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  HTTPManager.validStatusCode(httpURLResponse.statusCode) else {
                print("‼️ ERROR: \(String(decoding: data, as: UTF8.self))")
                throw AutoSpotoError.unexpectedHTTPUrlResponse
            }
            
            let gumroadVerification = try JSONDecoder().decode(GumroadVerification.self, from: data)
            
            return gumroadVerification.success &&
            gumroadVerification.uses <= 1 &&
            gumroadVerification.purchase.product_id == AutoSpotoConstants.Gumroad.autoSpotoProProductID &&
            !gumroadVerification.purchase.refunded &&
            !(gumroadVerification.purchase.disputed && gumroadVerification.purchase.dispute_won) &&
            !gumroadVerification.purchase.chargebacked
        } catch let error {
            print("😭 ERROR: \(error)")
            return false
        }
    }
}
