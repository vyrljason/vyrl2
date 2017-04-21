//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol WebViewControllerMaking: class {
    static func make(webViewContentUrl: URL) -> WebViewController
}

final class WebViewControllerFactory: WebViewControllerMaking {

    static func make(webViewContentUrl: URL) -> WebViewController {
        let interactor = WebViewInteractor(urlToDisplay: webViewContentUrl)
        let viewController = WebViewController(interactor: interactor)
        return viewController
    }
}
