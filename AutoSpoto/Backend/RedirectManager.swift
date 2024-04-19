//
//  RedirectManager.swift
//  AutoSpoto
//
//  Created by Andrew Caravaggio on 2024-04-16.
//
import Foundation

//function that resolves link urls to get the redirected track id

class URLResolver {
    func resolve(url: URL) async -> URL? {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        let config = URLSessionConfiguration.ephemeral
        config.httpAdditionalHeaders = [
            "User-Agent": "curl/8.4.0"
        ]
        config.requestCachePolicy = .reloadIgnoringCacheData
        
        let session = URLSession(configuration: config)

        do {
            let (_, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return nil
            }
            return httpResponse.url
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
