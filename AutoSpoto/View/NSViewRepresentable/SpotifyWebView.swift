//
//  SpotifyWebView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI
import WebKit

struct SpotifyWebView: NSViewRepresentable {
    @Binding var isVisible: Bool
    @Binding var userAuthorizedSpotify: Bool
    
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        //delegate
        webView.navigationDelegate = context.coordinator

        //load webview request
        let request = URLRequest(url: AutoSpotoConstants.URL.spotifyLogin)
        webView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SpotifyWebView
        
        init(_ parent: SpotifyWebView) {
            self.parent = parent
        }
        
        // Delegate methods go here
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            Task {
                do {
                    try await requestForCallbackURL(request: navigationAction.request)
                    
                } catch let error {
                    #warning("HANDLE ERROR")
                }
            }
            
            decisionHandler(.allow)
        }
        
        private func requestForCallbackURL(request: URLRequest) async throws {
            guard let requestURLString = request.url?.absoluteString else {
                return
            }

            if requestURLString.hasPrefix(redirectURI) {
                guard let code = requestURLString.getQueryStringParameter(param: "code"),
                      requestURLString.getQueryStringParameter(param: "error") == nil else {
                    throw AutoSpotoError.errorLoggingInToSpotify
                }
                try await SpotifyManager.fetchAndSaveToken(code: code)
                
                DispatchQueue.main.async {
                    self.parent.isVisible = false
                    self.parent.userAuthorizedSpotify = true
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
