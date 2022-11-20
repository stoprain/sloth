//
//  DocumentWebView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/18.
//

import SwiftUI
import WebKit

struct DocumentWebView: UIViewRepresentable {
    
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
//        let request = URLRequest(url: url)
//        print(url)
//        webView.scrollView.isPagingEnabled = true
//        webView.scrollView.alwaysBounceHorizontal = true
//        webView.scrollView.alwaysBounceVertical = false
//        webView.scrollView.bounces = true
        let c = url.deletingLastPathComponent().deletingLastPathComponent()
        print(c)
        webView.loadFileURL(url, allowingReadAccessTo: c)
//        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
//        webView.load(request)
    }
    
}
