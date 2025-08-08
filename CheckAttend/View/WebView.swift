//
//  WebView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/7/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        
        let request = URLRequest(url: url)
        webView.load(request)
        
#if DEBUG
        // WEBView 디버깅 (iOS 16.4이상) 개발 버전만 반영
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
        }
#endif
        
        return webView
        
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        // ✅ alert()
        func webView(_ webView: WKWebView,
                     runJavaScriptAlertPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo,
                     completionHandler: @escaping () -> Void) {
            
            guard let rootVC = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController else {
                completionHandler()
                return
            }

            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                completionHandler()
            })

            rootVC.present(alert, animated: true, completion: nil)
        }
        
        // ✅ confirm()
        func webView(_ webView: WKWebView,
                     runJavaScriptConfirmPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo,
                     completionHandler: @escaping (Bool) -> Void) {
            
            guard let rootVC = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController else {
                completionHandler(false) // 또는 completionHandler()
                return
            }
            
            let alert = UIAlertController(title: "확인", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                completionHandler(true)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                completionHandler(false)
            }))
            
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}
