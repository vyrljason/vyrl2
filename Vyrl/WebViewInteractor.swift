//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import WebKit
import UIKit

protocol ActivityIndicatorPresenter: class {
    func presentActivity()
    func dismissActivity()
}

protocol WebviewLoading: class {
    func load(urlRequest: URLRequest)
}

protocol WebViewInteracting: WKNavigationDelegate {
    weak var activityPresenter: ActivityIndicatorPresenter? { get set }
    weak var webViewLoader: WebviewLoading? { get set }
    func loadViewContent()
}

final class WebViewInteractor: NSObject, WebViewInteracting {

    private let url: URL
    weak var activityPresenter: ActivityIndicatorPresenter?
    weak var webViewLoader: WebviewLoading?

    init(urlToDisplay url: URL) {
        self.url = url
    }

    func loadViewContent() {
        let urlRequest = URLRequest(url: url)
        webViewLoader?.load(urlRequest: urlRequest)
    }
}

extension WebViewInteractor: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityPresenter?.presentActivity()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityPresenter?.dismissActivity()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityPresenter?.dismissActivity()
    }
}
