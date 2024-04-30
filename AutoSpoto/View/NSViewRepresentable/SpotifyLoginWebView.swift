//
//  SpotifyLoginWebView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-12.
//

import SwiftUI
import WebKit
//import FirebaseFirestore

struct SpotifyLoginWebView: NSViewRepresentable {
    @Binding var isVisible: Bool
    @Binding var userAuthorizedSpotify: Bool
    @Binding var isLoadingWebView: Bool
    
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
        var parent: SpotifyLoginWebView
        
        init(_ parent: SpotifyLoginWebView) {
            self.parent = parent
        }
        
        // Delegate methods go here
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            Task {
                do {
                    try await requestForCallbackURL(request: navigationAction.request)
                } catch let error {
                    //delete keychain item if it exists
                    SpotifyTokenManager.deleteToken()
                    
                    self.parent.isVisible = false
                    
                    assertionFailure("Error authenticating Spotify: \(error.localizedDescription)")
                }
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoadingWebView = false
        }
        
        private func requestForCallbackURL(request: URLRequest) async throws {
            guard let requestURLString = request.url?.absoluteString else {
                return
            }

            if requestURLString.hasPrefix(AutoSpotoConstants.URL.redirectURI) {
                guard let code = requestURLString.getQueryStringParameter(param: "code"),
                      requestURLString.getQueryStringParameter(param: "error") == nil else {
                    throw AutoSpotoError.errorLoggingInToSpotify
                }
                try await SpotifyManager.fetchAndSaveToken(code: code)
                
                //fail silently if fetch to get user's spotify ID fail, we will try again later
                try await SpotifyManager.fetchAndSaveUserSpotifyID()
                
                //send user id to DB
//                let spotifyUserID = UserDefaultsManager.spotifyUser.id
//                let db = Firestore.firestore()
//                let usersCollection = db.collection("users")
//                usersCollection.addDocument(data: [
//                    "spotifyID": spotifyUserID,
//                ]) { error in }
                
                DispatchQueue.main.async {
                    self.parent.isVisible = false
                    withAnimation {
                        self.parent.userAuthorizedSpotify = true
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
