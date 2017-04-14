//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol SettingsNavigating: class {
    weak var settingsNavigationController: UINavigationController? { get set }
    var account: AccountViewController! { get }
}

protocol WebviewPresenting: class {
    func presentWebview(with url: URL, animated: Bool)
}

protocol SharePresenting: class {
    func presentShare(with text: String, url: URL, animated: Bool)
}

final class SettingsNavigationBuilder {
    var accountFactory: AccountViewControllerMaking.Type = AccountViewControllerFactory.self
    var webviewFactory: WebViewControllerMaking.Type = WebViewControllerFactory.self
    
    func build() -> SettingsNavigating {
        return SettingsNavigation(accountFactory: accountFactory, webviewFactory: webviewFactory)
    }
}

final class SettingsNavigation: SettingsNavigating {
    weak var settingsNavigationController: UINavigationController?
    var account: AccountViewController!
    fileprivate let accountFactory: AccountViewControllerMaking.Type
    fileprivate let webviewFactory: WebViewControllerMaking.Type
    
    init (accountFactory: AccountViewControllerMaking.Type, webviewFactory: WebViewControllerMaking.Type) {
        self.accountFactory = accountFactory
        self.webviewFactory = webviewFactory
        account = accountFactory.make(webviewPresenter: self, sharePresenter: self)
    }
}

extension SettingsNavigation: WebviewPresenting {
    func presentWebview(with url: URL, animated: Bool) {
        let viewController = webviewFactory.make(webViewContentUrl: url)
        settingsNavigationController?.pushViewController(viewController, animated: animated)
    }
}

extension SettingsNavigation: SharePresenting {
    func presentShare(with text: String, url: URL, animated: Bool) {
        let objectsToShare: [Any] = [text, url]
        let viewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        viewController.setValue(text, forKey: "subject")
        settingsNavigationController?.present(viewController, animated: animated, completion: nil)
    }
}
