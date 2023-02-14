//
//  SpotifyWebView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI
import WebKit

struct SpotifyWebView: NSViewRepresentable {
    @Binding var spotifyAccessToken: String?

    var url: URL

    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        //delegate
        webView.navigationDelegate = context.coordinator

        //load webview request
        let request = URLRequest(url: url)
        webView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SpotifyWebView
        
        init(_ parent: SpotifyWebView) {
            self.parent = parent
        }
        
        // Delegate methods go here
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            requestForCallbackURL(request: navigationAction.request)
            decisionHandler(.allow)
        }
        
        private func requestForCallbackURL(request: URLRequest) {
            guard let requestURLString = request.url?.absoluteString else {
                return
            }

            if requestURLString.hasPrefix(redirectURI) {
                guard let code = requestURLString.getQueryStringParameter(param: "code") else {
                    fatalError("Could not get code from requestURLString")
                }

                sendPostRequest(code: code) { (data, response, error) in
                    if let error = error {
                        //TODO: handle error better?
                        print("Error: \(error)")
                        return
                    }

                    guard let data = data, let response = response as? HTTPURLResponse else {
                        //TODO: handle error better?
                        print("Error: No data or response")
                        return
                    }

                    if response.statusCode != 200 {
                        //TODO: handle error better?
                        print("Error: Response code is not 200")
                        return
                    }

                    guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else {
                        fatalError("Could not get JSON String")
                    }

                    let jsonObject = jsonString.toJSON() as? [String:AnyObject]

                    let access_string =  "{\"access_token\": \"\((jsonObject?["access_token"])!)\", "
                    let token_type = "\"token_type\": \"\((jsonObject?["token_type"])!)\", "
                    let expires_in = "\"expires_in\": \(3600), "
                    let scope = "\"scope\": \"\((jsonObject?["scope"])!)\", "
                    let expires_at = "\"expires_at\": \(Int (NSDate ().timeIntervalSince1970) + 3600), "
                    let refresh_token = "\"refresh_token\":\"\((jsonObject?["refresh_token"])!)\"}"

                    let final_json = access_string + token_type + expires_in + scope + expires_at + refresh_token

                    guard let cacheUrl = Bundle.main.urls(forResourcesWithExtension: "cache", subdirectory: nil)?.first else {
                        fatalError("Could not get .cache url")
                    }

                    do {
                        try final_json.write(toFile: cacheUrl.path, atomically: true, encoding: .utf8)
                        self.parent.spotifyAccessToken = final_json
                    } catch {
                        //TODO: handle error better?
                        print(error)
                    }
                }
            }
        }

        private func sendPostRequest(code: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
            let authOptions: [String: Any] = [
                "form": [
                    "grant_type": "authorization_code",
                    "redirect_uri": redirectURI,
                    "code": code,
                ],
                "headers": [
                    "Authorization": "Basic "
                    + (Data("\(clientID):\(clientSecret)".utf8).base64EncodedString())
                ],
                "json": true,
            ]

            var request = URLRequest(url: AutoSpotoConstants.URL.endpoint)
            request.httpMethod = "POST"

            if let headers = authOptions["headers"] as? [String: String] {
                for (headerField, headerValue) in headers {
                    request.setValue(headerValue, forHTTPHeaderField: headerField)
                }
            }

            if let form = authOptions["form"] as? [String: String] {
                let formData = form.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
                request.httpBody = formData
            }

            URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
