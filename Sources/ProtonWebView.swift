import SwiftUI
import WebKit
import AppKit
import UserNotifications

struct ProtonWebView: NSViewRepresentable {
    let initialURL: URL

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        config.userContentController.add(context.coordinator, name: NotificationForwardingScript.messageHandlerName)
        config.userContentController.addUserScript(
            WKUserScript(
                source: NotificationForwardingScript.source,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: false
            )
        )

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true

        webView.load(URLRequest(url: initialURL))
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        private let allowedHostSuffixes: [String] = [
            "proton.me",
        ]

        private func isAllowedInWebView(_ url: URL) -> Bool {
            guard let scheme = url.scheme?.lowercased() else { return false }

            if scheme == "about" || scheme == "file" { return true }
            if scheme != "http" && scheme != "https" { return false }

            guard let host = url.host?.lowercased() else { return false }
            return allowedHostSuffixes.contains(where: { host == $0 || host.hasSuffix("." + $0) })
        }

        private func openExternally(_ url: URL) {
            NSWorkspace.shared.open(url)
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }

            // If the page tries to open a new window (target=_blank), keep single-window
            // behavior by opening externally when it's not a Proton domain.
            if navigationAction.targetFrame == nil {
                if isAllowedInWebView(url) {
                    webView.load(URLRequest(url: url))
                } else {
                    openExternally(url)
                }
                decisionHandler(.cancel)
                return
            }

            // Open external links in the system browser instead of inside the webview.
            if navigationAction.navigationType == .linkActivated && !isAllowedInWebView(url) {
                openExternally(url)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == NotificationForwardingScript.messageHandlerName else { return }

            if let payload = message.body as? [String: Any] {
                let title = (payload["title"] as? String) ?? ""
                let body = payload["body"] as? String
                if !title.isEmpty || (body?.isEmpty == false) {
                    AppNotificationBridge.shared.post(title: title.isEmpty ? "Notification" : title, body: body)
                }
            } else if let text = message.body as? String, !text.isEmpty {
                AppNotificationBridge.shared.post(title: "Notification", body: text)
            }
        }
    }
}

