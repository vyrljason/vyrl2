//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol WebViewControllerBuilding: class {
    var webViewContentUrl: URL? { get set }

    func build() -> WebViewController?
}

final class WebViewControllerBuilder: WebViewControllerBuilding {

    var webViewContentUrl: URL?

    func build() -> WebViewController? {
        guard let webViewContentUrl = webViewContentUrl else { return nil }
        let interactor = WebViewInteractor(urlToDisplay: webViewContentUrl)
        let viewController = WebViewController(interactor: interactor)
        return viewController
    }
}
