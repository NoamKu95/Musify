//
//  AuthViewController.swift
//  Musify
//
//  Created by Noam Kurtzer on 24/06/2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
       let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self // to detect redirects in webview
        view.addSubview(webView)
        guard let url = AuthManager.shared.url else {
            return
        }
        webView.load(URLRequest(url: url))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange code for access token:
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        webView.isHidden = true
        print("Code: \(code)")
        
        AuthManager.shared.exchangeCodeToAccessToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
    
}
