//
//  UpgradeToAutoSpotoProWebView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-24.
//

import SwiftUI
import WebKit
import AppKit

struct UpgradeToAutoSpotoProWebView: NSViewRepresentable {
    @Binding var isLoadingWebView: Bool
    @Binding var retrievedLicenseKey: String?
    
    @Binding var userPurchasedLicense: Bool
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        //delegate
        webView.navigationDelegate = context.coordinator
        
        //load webview request
        let request = URLRequest(url: AutoSpotoConstants.URL.autoSpotoProProduct)
        webView.load(request)
        
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        //
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: UpgradeToAutoSpotoProWebView
        
        init(_ parent: UpgradeToAutoSpotoProWebView) {
            self.parent = parent
        }
        
        // Delegate methods go here
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            Task {
                do {
                    try await requestForCallbackURL(request: navigationAction.request)
                } catch let error {
                    assertionFailure("Error purchasing product: \(error.localizedDescription)")
                }
            }
            
            decisionHandler(.allow)
        }
        
        private func requestForCallbackURL(request: URLRequest) async throws {
            guard let requestURLString = request.url?.absoluteString else {
                return
            }
            
            if requestURLString.contains(AutoSpotoConstants.URL.autoSpotoProProductReceipt.absoluteString) {
                //user has purchased product
                parent.userPurchasedLicense = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoadingWebView = false
            
            if parent.userPurchasedLicense {
                webView.evaluateJavaScript("document.getElementsByTagName('strong')[0].innerText") { result, error in
                    guard error == nil, let licenseKey = result as? String else {
                        return
                    }
                    
                    self.parent.retrievedLicenseKey = licenseKey
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
