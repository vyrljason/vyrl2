//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let alertYes: String = NSLocalizedString("general.button.alert.yes", comment: "")
    static let alertNo: String = NSLocalizedString("general.button.alert.no", comment: "")
}

protocol SettingsNavigating: class {
    weak var settingsNavigationController: UINavigationController? { get set }
    weak var loginPresenter: AuthorizationScreenPresenting? { get set }
    var account: AccountViewController! { get }
}

protocol WebviewPresenting: class {
    func presentWebview(with url: URL, animated: Bool)
}

protocol SharePresenting: class {
    func presentShare(with text: String, url: URL, animated: Bool)
}

protocol AlertPresenting: class {
    func presentAlert(with title: String?, message: String?, onAccept: ((UIAlertAction) -> Void)?)
}

protocol SettingsDismissing: class {
    func dismiss()
}

protocol ProfilePresenting: class {
    func presentProfile(with userProfile: UserProfile, animated: Bool)
}

final class SettingsNavigationBuilder {
    var accountFactory: AccountViewControllerMaking.Type = AccountViewControllerFactory.self
    var webviewFactory: WebViewControllerMaking.Type = WebViewControllerFactory.self
    var profileFactory: ProfileViewControllerMaking.Type = ProfileViewControllerFactory.self
    
    func build() -> SettingsNavigating {
        return SettingsNavigation(accountFactory: accountFactory, webviewFactory: webviewFactory,
                                  profileFactory: profileFactory)
    }
}

final class SettingsNavigation: SettingsNavigating {
    weak var settingsNavigationController: UINavigationController?
    weak var loginPresenter: AuthorizationScreenPresenting?
    var account: AccountViewController!
    fileprivate let accountFactory: AccountViewControllerMaking.Type
    fileprivate let webviewFactory: WebViewControllerMaking.Type
    fileprivate let profileFactory: ProfileViewControllerMaking.Type
    
    init (accountFactory: AccountViewControllerMaking.Type, webviewFactory: WebViewControllerMaking.Type,
          profileFactory: ProfileViewControllerMaking.Type) {
        self.accountFactory = accountFactory
        self.webviewFactory = webviewFactory
        self.profileFactory = profileFactory
        account = accountFactory.make(webviewPresenter: self, sharePresenter: self,
                                      alertPresenter: self, settingsDismisser: self,
                                      profilePresenter: self)
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

extension SettingsNavigation: AlertPresenting {
    func presentAlert(with title: String?, message: String?, onAccept: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: Constants.alertYes, style: .destructive, handler: onAccept)
        let noAction = UIAlertAction(title: Constants.alertNo, style: .cancel, handler: nil)
        controller.addAction(noAction)
        controller.addAction(yesAction)
        settingsNavigationController?.present(controller, animated: true, completion: nil)
    }
}

extension SettingsNavigation: SettingsDismissing {
    func dismiss() {
        loginPresenter?.showAuthorization()
        settingsNavigationController?.dismiss(animated: true, completion: nil)
    }
}

extension SettingsNavigation: ProfilePresenting {
    func presentProfile(with userProfile: UserProfile, animated: Bool) {
        let viewController = profileFactory.make(userProfile: userProfile)
        settingsNavigationController?.pushViewController(viewController, animated: animated)
    }
}
