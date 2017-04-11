//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol WebViewControllerBuilding: class {
    func build(webViewContentUrl: URL) -> WebViewController
}

final class WebViewControllerBuilder: WebViewControllerBuilding {

    func build(webViewContentUrl: URL) -> WebViewController {
        let interactor = WebViewInteractor(urlToDisplay: webViewContentUrl)
        let viewController = WebViewController(interactor: interactor)
        return viewController
    }
}
