//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import WebKit
import UIKit

final class WebViewController: UIViewController, HavingNib {
    static let nibName = "WebViewController"

    fileprivate var webView: WKWebView!
    @IBOutlet fileprivate weak var webViewContainer: UIView!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    private let interactor: WebViewInteracting

    init(interactor: WebViewInteracting) {
        self.interactor = interactor
        super.init(nibName: WebViewController.nibName, bundle: nil)
        self.interactor.activityPresenter = self
        self.interactor.webViewLoader = self
        edgesForExtendedLayout = []
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpWebView() {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        webView.pinToEdges(of: webViewContainer)
        webView.navigationDelegate = interactor
    }

    override func viewDidLoad() {
        setUpWebView()
        interactor.loadViewContent()
    }
}

extension WebViewController: WebviewLoading {
    func load(urlRequest: URLRequest) {
        webView.load(urlRequest)
    }
}

extension WebViewController: ActivityIndicatorPresenter {
    func presentActivity() {
        activityIndicator.startAnimating()
    }

    func dismissActivity() {
        activityIndicator.stopAnimating()
    }
}
