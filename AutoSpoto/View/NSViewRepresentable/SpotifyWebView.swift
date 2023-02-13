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
        
        func requestForCallbackURL(request: URLRequest) {
            // Get the access token string after the '#access_token=' and before '&token_type='
            let requestURLString = (request.url?.absoluteString)! as String
            if requestURLString.hasPrefix(redirectURI) {
                if requestURLString.contains("#access_token=") {
                    if let range = requestURLString.range(of: "=") {
                        let spotifAcTok = requestURLString[range.upperBound...]
                        if let range = spotifAcTok.range(of: "&token_type=") {
                            let spotifAcTokFinal = spotifAcTok[..<range.lowerBound]
                            handleAuth(spotifyAccessToken: String(spotifAcTokFinal))
                        }
                    }
                }
            }
        }
        
        func handleAuth(spotifyAccessToken: String) {
            parent.spotifyAccessToken = spotifyAccessToken
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
