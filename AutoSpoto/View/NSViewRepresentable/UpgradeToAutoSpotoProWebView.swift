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
    @Binding var userHasPurchasedLicense: Bool
    @Binding var isLoadingWebView: Bool
    @Binding var licenseKey: String
    
    @State var isNavigatingToReceiptPage = false
    
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        //delegate
        webView.navigationDelegate = context.coordinator

        //load webview request
        let request = URLRequest(url: AutoSpotoConstants.URL.autoSpotoProProduct)
        webView.load(request)
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
            
            if requestURLString.contains(AutoSpotoConstants.URL.autoSpotoProProductReceipt) {
                //user has purchased product
                parent.isNavigatingToReceiptPage = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoadingWebView = false
            
            if parent.isNavigatingToReceiptPage {
                webView.evaluateJavaScript("document.getElementsByTagName('strong')[0].innerText") { result, error in
                    self.parent.userHasPurchasedLicense = true
                    
                    guard error == nil, let licenseKey = result as? String else {
                        return
                    }
                    
                    self.parent.licenseKey = licenseKey
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
