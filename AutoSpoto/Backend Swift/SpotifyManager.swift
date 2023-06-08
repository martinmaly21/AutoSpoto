//
//  SpotifyManager.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

class SpotifyManager {
    private static func url(
        path: String,
        params: [String: Any]? = nil,
        isTokenFetch: Bool = false
    ) -> URL {
        var queryString = ""
        if let params = params {
            queryString = "?"
            params.forEach { k, v in
                queryString += "\(k)=\(v)&"
            }
        }
        let path = path.trimmingCharacters(in: .init(charactersIn: "/"))
        queryString = queryString.trimmingCharacters(in: .init(charactersIn: "&"))
        let urlString = "\(isTokenFetch ? AutoSpotoConstants.URL.spotifyAuthEndpoint : AutoSpotoConstants.URL.spotifyWebAPIEndPoint)/\(path)/\(queryString)"
        return URL(string: urlString)!
    }
    
    private static func headers(isTokenFetch: Bool) async throws -> [String: String] {
        var headers = [
            AutoSpotoConstants.HTTPHeaders.contentType: "application/x-www-form-urlencoded",
        ]
        
        guard !isTokenFetch else {
            headers[AutoSpotoConstants.HTTPHeaders.authorization] = "Basic \((Data("\(clientID):\(clientSecret)".utf8).base64EncodedString()))"
            return headers
        }
        
        if var token = KeychainManager.standard.read(
            service: AutoSpotoConstants.KeyChain.service,
            account: AutoSpotoConstants.KeyChain.account,
            type: Token.self
        ) {
            if token.accessTokenHasExpired {
                token = try await refreshTokenAndSaveToken(expiredToken: token)
            }
            
            headers[AutoSpotoConstants.HTTPHeaders.authorization] = "Bearer \(token.access_token))"
        }
        
        return headers
    }
    
    private static func http(
        method: HTTPMethodType,
        path: String,
        isTokenFetch: Bool = false
    ) async throws -> Data {
        let httpURL: URL
        switch method {
        case .get(let queryParams):
            httpURL = url(path: path, params: queryParams, isTokenFetch: isTokenFetch)
        case .post, .put, .delete:
            httpURL = url(path: path, isTokenFetch: isTokenFetch)
        }
        
        var request = URLRequest(url: httpURL)
        request.httpMethod = method.httpMethod
        
        //update headers
        let headers = try await headers(isTokenFetch: isTokenFetch)
        for (headerField, headerValue) in headers {
            request.setValue(
                headerValue,
                forHTTPHeaderField: headerField
            )
        }
        
        if let form = method.data {
            let formData = form.map { "\($0)=\($1)" }
                .joined(separator: "&")
                .data(using: .utf8)
            request.httpBody = formData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  validStatusCode(httpURLResponse.statusCode) else {
                
                let parsedData = String(decoding: data, as: UTF8.self)
                print("‼️ ERROR: \(parsedData)")
                throw AutoSpotoError.unexpectedHTTPUrlResponse
            }
            
            return data
        } catch let error {
            print("😭 ERROR: \(error)")
            throw error
        }
    }
    
    private static func validStatusCode(_ statusCode: Int) -> Bool {
        switch statusCode {
        case AutoSpotoConstants.HTTPStatus.ok,
            AutoSpotoConstants.HTTPStatus.created,
            AutoSpotoConstants.HTTPStatus.accepted,
            AutoSpotoConstants.HTTPStatus.noContent,
            AutoSpotoConstants.HTTPStatus.movedPermanently,
            AutoSpotoConstants.HTTPStatus.found,
            AutoSpotoConstants.HTTPStatus.movedTemporarily,
            AutoSpotoConstants.HTTPStatus.temporaryRedirect,
            AutoSpotoConstants.HTTPStatus.permanentRedirect:
            return true
        default:
            return false
        }
    }
   
    public static func fetchAndSaveToken(code: String) async throws {
        let params = [
            AutoSpotoConstants.HTTPParameter.grant_type: "authorization_code",
            AutoSpotoConstants.HTTPParameter.redirect_uri: redirectURI,
            AutoSpotoConstants.HTTPParameter.code: code,
        ]
        let data = try await http(method: .post(data: params), path: "/token", isTokenFetch: true)
        let token = try JSONDecoder().decode(Token.self, from: data)
        
        KeychainManager.saveSpotifyTokenInKeychain(token: token)
    }
    
    public static func refreshTokenAndSaveToken(expiredToken: Token) async throws -> Token {
        let params = [
            AutoSpotoConstants.HTTPParameter.grant_type: "refresh_token",
            AutoSpotoConstants.HTTPParameter.refresh_token: expiredToken.refresh_token
        ]
        let data = try await http(method: .post(data: params), path: "/token", isTokenFetch: true)
        let token = try JSONDecoder().decode(Token.self, from: data)
        
        KeychainManager.saveSpotifyTokenInKeychain(token: token)
        
        return token
    }
    
    
    public static func getUserSpotifyID() async throws {
        let data = try await http(method: .post(data: nil), path: "/me")
        
        print("Data: \(data)")
    }
}
