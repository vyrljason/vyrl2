//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import WebKit
@testable import Vyrl
import XCTest

final class ActivityIndicatorPresenterMock: ActivityIndicatorPresenter {
    var didCallPresent = false
    var didCallDismiss = false

    func presentActivity() {
        didCallPresent = true
    }

    func dismissActivity() {
        didCallDismiss = true
    }
}

final class WebviewLoaderMock: WebviewLoading {
    var lastUrlRequest: URLRequest?

    func load(urlRequest: URLRequest) {
        lastUrlRequest = urlRequest
    }
}

protocol WebViewInteracting: WKNavigationDelegate {
    weak var activityPresenter: ActivityIndicatorPresenter? { get set }
    weak var webViewLoader: WebviewLoading? { get set }
    func loadViewContent()
}

final class WebViewInteractorTest: XCTestCase {

    private var url: URL!
    private var webView: WKWebView!
    private var navigation: WKNavigation!
    private var subject: WebViewInteractor!
    private var activityPresenter: ActivityIndicatorPresenterMock!
    private var webViewLoader: WebviewLoaderMock!

    override func setUp() {
        super.setUp()
        url = URL(string: "http://umbrella.inc")!
        activityPresenter = ActivityIndicatorPresenterMock()
        webViewLoader = WebviewLoaderMock()
        webView = WKWebView(frame: CGRect.zero)
        navigation = WKNavigation()
        subject = WebViewInteractor(urlToDisplay: url)
        subject.activityPresenter = activityPresenter
        subject.webViewLoader = webViewLoader
    }

    func test_loadViewContent_callsWebviewLoaderWithProperURL() {
        subject.loadViewContent()

        XCTAssertEqual(url, webViewLoader.lastUrlRequest?.url)
    }

    func test_didStartProvisionalNavigation_presentsActivity() {
        subject.webView(webView, didStartProvisionalNavigation: navigation)

        XCTAssertTrue(activityPresenter.didCallPresent)
    }

    func test_didFinishNavigation_dismissActivity() {
        subject.webView(webView, didFinish: navigation)

        XCTAssertTrue(activityPresenter.didCallDismiss)
    }

    func test_didFailNavigation_dismissActivity() {
        let error = NSError(domain: "domain", code: 666, userInfo: nil)

        subject.webView(webView, didFail: navigation, withError: error)

        XCTAssertTrue(activityPresenter.didCallDismiss)
    }
}
