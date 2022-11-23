//
//  DocumentWebView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/18.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let w = WKWebView()
        w.navigationDelegate = context.coordinator
        w.configuration.userContentController.add(context.coordinator, name: "newSelectionDetected")
        let scriptString = """
        
            const getWord = (s, pos) => {
                const n = s.substring(pos).match(/^[a-zA-Z0-9-_]+/)
                const p = s.substring(0, pos).match(/[a-zA-Z0-9-_]+$/)
                // if you really only want the word if you click at start or between
                // but not at end instead use if (!n) return
                if(!p && !n) return ''
                return (p || '') + (n || '')
            }
        
            function getSelectionAndSendMessage(event)
            {
                var range = document.caretRangeFromPoint(event.clientX, event.clientY);
                var word = getWord(range.startContainer.textContent, range.startOffset);
                
                window.webkit.messageHandlers.newSelectionDetected.postMessage(word);
            }
            document.onmouseup = getSelectionAndSendMessage;
            document.onkeyup = getSelectionAndSendMessage;
            document.oncontextmenu = getSelectionAndSendMessage;
        """
        let script = WKUserScript(source: scriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        w.configuration.userContentController.addUserScript(script)
        
        return w
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        
        var finishFirstNavigation = false
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let word = message.body as? String else { return }
            Translator.shared.input = word
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            finishFirstNavigation = true
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if finishFirstNavigation {
                decisionHandler(WKNavigationActionPolicy.cancel, preferences)
            } else {
                decisionHandler(WKNavigationActionPolicy.allow, preferences)
            }
        }
    }
    
}
