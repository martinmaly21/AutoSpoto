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
            guard let requestURLString = request.url?.absoluteString else {
                return
            }


            if requestURLString.hasPrefix(redirectURI) {
                let code = requestURLString.getQueryStringParameter(param: "code")

                //Do next shit
                print("Test: \(code)")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
