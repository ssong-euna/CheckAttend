//
//  SafariWebView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/8/25.
//

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = context.coordinator
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // URL이 바뀔 경우 새로 로드하고 싶다면 별도 처리 필요
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        // 필요 시 delegate 메서드 구현 가능
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            print("SafariViewController dismissed")
        }
    }
}
