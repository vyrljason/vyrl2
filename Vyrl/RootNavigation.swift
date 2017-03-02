//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

protocol MainNavigationPresenting: class {
    func presentMainNavigation(animated: Bool)
}

protocol AuthorizationFlowPresenting: class {
    func presentAuthorizationNavigation(animated: Bool)
}

protocol RootNavigationControlling: class {
    func showMenu()
    func showChat()
    func showCart()
    func dismissModal()
}

protocol AuthorizationScreenPresenting {
    func showAuthorization()
}

protocol HomeScreenPresenting: class {
    func showHome()
}

protocol AccountScreenPresenting: class {
    func showAccount()
}

protocol CategoryPresenting: class {
    func show(_ category: Category)
}

final class RootNavigation {

    fileprivate enum Constants {
        static let menuWidthRatio: CGFloat = 0.8
        static let contentViewScale: CGFloat = 1.0
        static let titleImage: UIImage = StyleKit.navigationBarLogo
        static let navigationBarRenderable = NavigationBarRenderable(tintColor: .white,
                                                                     titleFont: .titleFont,
                                                                     backgroundColor: .rouge,
                                                                     translucent: false)
        static let closeTitle: String = NSLocalizedString("Close", comment: "")
        static let animationDuration: TimeInterval = 0.3
    }

    fileprivate var mainNavigation: NavigationControlling
    fileprivate let window: WindowProtocol
    fileprivate var slideMenu: SlideMenuController!
    fileprivate let leftMenu: UIViewController
    fileprivate let cart: UIViewController
    fileprivate let chat: UIViewController
    fileprivate let accountMaker: AccountViewControllerMaking.Type
    fileprivate let interactor: RootNavigationInteracting & NavigationDelegateHaving
    fileprivate let credentialsProvider: APICredentialsProviding
    fileprivate let loginControllerMaker: LoginControllerMaking.Type

    weak var brandsFiltering: BrandsFilteringByCategory?

    // swiftlint:disable function_parameter_count
    init(interactor: RootNavigationInteracting & NavigationDelegateHaving,
         leftMenu: UIViewController,
         mainNavigation: NavigationControlling,
         cart: UIViewController,
         chat: UIViewController,
         accountMaker: AccountViewControllerMaking.Type,
         window: WindowProtocol,
         credentialsProvider: APICredentialsProviding,
         loginControllerMaker: LoginControllerMaking.Type) {
        self.interactor = interactor
        self.mainNavigation = mainNavigation
        self.leftMenu = leftMenu
        self.cart = cart
        self.chat = chat
        self.accountMaker = accountMaker
        self.window = window
        self.credentialsProvider = credentialsProvider
        self.loginControllerMaker = loginControllerMaker
        interactor.delegate = self
        setUpSlideMenu()
    }

    private func setUpSlideMenu() {
        setUpSlideMenuOptions()
        slideMenu = SlideMenuController(mainViewController: mainNavigation.navigationController,
                                        leftMenuViewController: leftMenu)
    }

    fileprivate func presentModally(_ viewController: UIViewController) {
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        let close = UIBarButtonItem(title: Constants.closeTitle,
                                    style: .done,
                                    target: interactor,
                                    action: #selector(RootNavigationInteracting.didTapClose))
        viewController.navigationItem.leftBarButtonItem = close
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.render(Constants.navigationBarRenderable)
        mainNavigation.present(navigation, animated: true)
    }

    fileprivate func transition(to controller: UIViewController, animated: Bool = true) {
        guard let window = window as? UIView else { return }
        let switchAction = {
            self.window.rootViewController = controller
            self.makeWindowKeyAndVisible()
        }
        if animated {
            UIView.transition(with: window,
                              duration: Constants.animationDuration,
                              options: .transitionCrossDissolve,
                              animations: {
                                switchAction()
            }, completion: nil)
        } else {
            switchAction()
        }

    }

    fileprivate func makeWindowKeyAndVisible() {
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
    }

    private func setUpSlideMenuOptions() {
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.size.width * Constants.menuWidthRatio
        SlideMenuOptions.contentViewScale = Constants.contentViewScale
        SlideMenuOptions.contentViewDrag = true
    }
}

extension RootNavigation {
    func showInitialViewController(animated: Bool = true) {
        if credentialsProvider.userAccessToken != nil {
            presentMainNavigation(animated: animated)
        } else {
            presentAuthorizationNavigation(animated: animated)
        }
    }
}

extension RootNavigation: AuthorizationFlowPresenting {
    func presentAuthorizationNavigation(animated: Bool) {
        let viewController = loginControllerMaker.make(using: self)
        viewController.render(NavigationItemRenderable(titleImage: Constants.titleImage))
        let authorizationNavigation = UINavigationController(rootViewController: viewController)
        authorizationNavigation.render(Constants.navigationBarRenderable)

        transition(to: authorizationNavigation, animated: animated)
    }
}

extension RootNavigation: AuthorizationListener {
    func didFinishAuthorizing() {
        presentMainNavigation(animated: true)
    }
}

extension RootNavigation: MainNavigationPresenting {
    func presentMainNavigation(animated: Bool) {
        setUpMainNavigationController()
        transition(to: slideMenu, animated: animated)
    }

    private func setUpMainNavigationController() {
        guard let topViewController = mainNavigation.navigationController.topViewController else { return }
        setUpNavigationItems(in: topViewController)
        mainNavigation.navigationController.render(Constants.navigationBarRenderable)
    }

    private func setUpNavigationItems(in viewController: UIViewController) {
        viewController.render(NavigationItemRenderable(titleImage: Constants.titleImage))

        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "burger"),
                                         style: .plain,
                                         target: interactor,
                                         action: #selector(RootNavigationInteracting.didTapMenu))

        viewController.navigationItem.leftBarButtonItem = menuButton

        // This is temporary - icon will be used.
        let chat = UIBarButtonItem(title: "Chat",
                                   style: .plain,
                                   target: interactor,
                                   action: #selector(RootNavigationInteracting.didTapChat))

        let cart = UIBarButtonItem(image: #imageLiteral(resourceName: "iosCartIconNav"),
                                   style: .plain,
                                   target: interactor,
                                   action: #selector(RootNavigationInteracting.didTapCart))

        viewController.navigationItem.rightBarButtonItems = [chat, cart]
    }
}

extension RootNavigation: HomeScreenPresenting {
    func showHome() {
        mainNavigation.goToFirst(animated: true)
        slideMenu.closeLeft()
    }
}

extension RootNavigation: CategoryPresenting {
    func show(_ category: Category) {
        mainNavigation.goToFirst(animated: true) // FIXME: show brands for category
        brandsFiltering?.filterBrands(by: category)
        slideMenu.closeLeft()
    }
}

extension RootNavigation: AccountScreenPresenting {
    func showAccount() {
        let account = accountMaker.make()
        presentModally(account)
        slideMenu.closeLeft()
    }
}

extension RootNavigation: AuthorizationScreenPresenting {
    func showAuthorization() {
        slideMenu.closeLeft()
        presentAuthorizationNavigation(animated: true)
    }
}

extension RootNavigation: RootNavigationControlling {
    func showMenu() {
        slideMenu.openLeft()
    }

    func showChat() {
        presentModally(chat)
    }

    func showCart() {
        presentModally(cart)
    }

    func dismissModal() {
        mainNavigation.dismiss(animated: true)
    }
}
