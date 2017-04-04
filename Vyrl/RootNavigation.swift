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
    func dismissModal()
}

protocol ChatPresenting: class {
    func showChat()
}

protocol CartPresenting: class {
    func showCart()
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

protocol MainNavigationRendering: class {
    func setUpMainNavigationItems(in viewController: UIViewController)
}

@objc protocol CartUpdateObserving {
    func cartUpdated(notification: Notification)
}

@objc protocol UnreadMessagesCountObserving {
    func unreadMessagesUpdated(notification: Notification)
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
        static let leftButtonNegativeSpace: CGFloat = -8
    }

    fileprivate var cart: CartNavigating
    fileprivate var mainNavigation: NavigationControlling
    fileprivate let window: WindowProtocol
    fileprivate var slideMenu: SlideMenuController!
    fileprivate let leftMenu: UIViewController
    fileprivate var chat: ChatNavigating
    fileprivate let accountMaker: AccountViewControllerMaking.Type
    fileprivate let interactor: RootNavigationInteracting & NavigationDelegateHaving
    fileprivate let credentialsProvider: APICredentialsProviding
    fileprivate let loginControllerMaker: LoginControllerMaking.Type
    fileprivate var cartButton: BadgeBarButtonItem?
    fileprivate var chatButton: BadgeBarButtonItem?
    fileprivate let notificationObserver: NotificationObserving
    fileprivate let cartStorage: CartStoring

    weak var brandsFiltering: BrandsFilteringByCategory?

    // swiftlint:disable function_parameter_count
    init(interactor: RootNavigationInteracting & NavigationDelegateHaving,
         leftMenu: UIViewController,
         mainNavigation: NavigationControlling,
         cart: CartNavigating,
         chat: ChatNavigating,
         accountMaker: AccountViewControllerMaking.Type,
         window: WindowProtocol,
         credentialsProvider: APICredentialsProviding,
         loginControllerMaker: LoginControllerMaking.Type,
         notificationObserver: NotificationObserving,
         cartStorage: CartStoring) {
        self.interactor = interactor
        self.mainNavigation = mainNavigation
        self.leftMenu = leftMenu
        self.cart = cart
        self.chat = chat
        self.accountMaker = accountMaker
        self.window = window
        self.credentialsProvider = credentialsProvider
        self.loginControllerMaker = loginControllerMaker
        self.notificationObserver = notificationObserver
        self.cartStorage = cartStorage
        interactor.delegate = self
        cart.chatPresenter = self
        setUpSlideMenu()
        setUpNavigationItems()
        notificationObserver.addObserver(self, selector: #selector(cartUpdated), name: cartUpdateNotificationName, object: nil)
        notificationObserver.addObserver(self, selector: #selector(unreadMessagesUpdated), name: unreadMessagesUpdateNotificationName, object: nil)
    }

    private func setUpNavigationItems() {
        cartButton = BadgeBarButtonItem(image: #imageLiteral(resourceName: "iosCartIconNav"),
                                        style: .plain) { [weak self] in
                                            self?.interactor.didTapCart()
        }

        chatButton = BadgeBarButtonItem(image: #imageLiteral(resourceName: "chat_icon"),
                                        style: .plain) { [weak self] in
                                            self?.interactor.didTapChat()
        }
        updateCartButton(using: CountableItemUpdate(itemsCount: cartStorage.items.count))
    }

    private func setUpSlideMenu() {
        setUpSlideMenuOptions()
        slideMenu = SlideMenuController(mainViewController: mainNavigation.navigationController,
                                        leftMenuViewController: leftMenu)
    }

    @discardableResult fileprivate func presentModally(_ viewController: UIViewController) -> UINavigationController {
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        let close = UIBarButtonItem(title: Constants.closeTitle,
                                    style: .plain,
                                    target: interactor,
                                    action: #selector(RootNavigationInteracting.didTapClose))
        viewController.navigationItem.leftBarButtonItem = close
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.render(Constants.navigationBarRenderable)
        mainNavigation.present(navigation, animated: true)
        return navigation
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
        let negativeButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeButton.width = Constants.leftButtonNegativeSpace

        viewController.navigationItem.leftBarButtonItems = [negativeButton, menuButton]
        guard let cartButton = cartButton, let chatButton = chatButton else { return }
        viewController.navigationItem.rightBarButtonItems = [cartButton, chatButton]
    }
}

extension RootNavigation: HomeScreenPresenting {
    func showHome() {
        mainNavigation.goToFirst(animated: true)
        brandsFiltering?.filterBrands(by: nil)
        slideMenu.closeLeft()
    }
}

extension RootNavigation: CategoryPresenting {
    func show(_ category: Category) {
        mainNavigation.goToFirst(animated: true)
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

extension RootNavigation: CartPresenting {
    func showCart() {
        let navigation = presentModally(cart.cart)
        cart.cartNavigationController = navigation
    }
}

extension RootNavigation: ChatPresenting {
    func showChat() {
        let navigation = presentModally(chat.collabs)
        chat.chatNavigationController = navigation
    }
}

extension RootNavigation: RootNavigationControlling {
    func showMenu() {
        slideMenu.openLeft()
    }

    func dismissModal() {
        mainNavigation.dismiss(animated: true)
    }
}

extension RootNavigation: MainNavigationRendering {
    func setUpMainNavigationItems(in viewController: UIViewController) {
        viewController.renderNoTitleBackButton()
        guard let cartButton = cartButton, let chatButton = chatButton else { return }
        viewController.navigationItem.rightBarButtonItems = [cartButton, chatButton]
    }
}

extension RootNavigation: CartUpdateObserving {
    @objc func cartUpdated(notification: Notification) {
        guard let updateInfo = CountableItemUpdate(dictionary: notification.userInfo) else { return }
        updateCartButton(using: updateInfo)
    }

    fileprivate func updateCartButton(using updateInfo: CountableItemUpdate) {
        cartButton?.render(BadgeButtonRenderable(itemsCount: updateInfo.itemsCount))
    }
}

extension RootNavigation: UnreadMessagesCountObserving {
    @objc func unreadMessagesUpdated(notification: Notification) {
        guard let updateInfo = CountableItemUpdate(dictionary: notification.userInfo) else { return }
        updateMessagesButton(using: updateInfo)
    }

    fileprivate func updateMessagesButton(using updateInfo: CountableItemUpdate) {
        chatButton?.render(BadgeButtonRenderable(itemsCount: updateInfo.itemsCount))
    }
}
