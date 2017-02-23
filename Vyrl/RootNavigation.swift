//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

protocol RootNavigationControlling: class {
    func showMenu()
    func showChat()
    func showCart()
    func dismissModal()
}

protocol HomeScreenPresenting: class {
    func showHome()
}

protocol CategoryPresenting: class {
    func show(_ category: Category)
}

final class RootNavigation {

    private enum Constants {
        static let menuWidthRatio: CGFloat = 0.8
        static let contentViewScale: CGFloat = 1.0
        static let titleImage: UIImage = UIImage()
        static let navigationBarRenderable = NavigationBarRenderable(tintColor: .white,
                                                                     titleFont: .titleFont,
                                                                     backgroundColor: .rouge,
                                                                     translucent: false)
        static let closeTitle: String = NSLocalizedString("Close", comment: "")
    }

    fileprivate var mainNavigation: NavigationControlling
    private let window: WindowProtocol
    fileprivate var slideMenu: SlideMenuController!
    private let leftMenu: UIViewController
    fileprivate let cart: UIViewController
    fileprivate let chat: UIViewController
    private let interactor: RootNavigationInteracting & NavigationDelegateHaving

    // swiftlint:disable function_parameter_count
    init(interactor: RootNavigationInteracting & NavigationDelegateHaving,
         leftMenu: UIViewController,
         mainNavigation: NavigationControlling,
         cart: UIViewController,
         chat: UIViewController,
         window: WindowProtocol) {
        self.interactor = interactor
        self.mainNavigation = mainNavigation
        self.leftMenu = leftMenu
        self.cart = cart
        self.chat = chat
        self.window = window
        interactor.delegate = self
    }

    func showInitialViewController() {
        setUpSlideMenuOptions()
        presentSlideMenu()
    }

    private func presentSlideMenu() {
        setUpMainNavigationController()
        createAndPresentSlideMenu()
    }
    private func setUpNavigationItems(in viewController: UIViewController) {
        viewController.render(NavigationItemRenderable(titleImage: Constants.titleImage))

        // This is temporary - icon will be used.
        let menuButton = UIBarButtonItem(title: "Menu",
                                         style: .plain,
                                         target: interactor,
                                         action: #selector(RootNavigationInteracting.didTapMenu))

        viewController.navigationItem.leftBarButtonItem = menuButton

        // This is temporary - icon will be used.
        let chat = UIBarButtonItem(title: "Chat",
                                   style: .plain,
                                   target: interactor,
                                   action: #selector(RootNavigationInteracting.didTapChat))

        // This is temporary - icon will be used.
        let cart = UIBarButtonItem(title: "Cart",
                                   style: .plain,
                                   target: interactor,
                                   action: #selector(RootNavigationInteracting.didTapCart))

        viewController.navigationItem.rightBarButtonItems = [chat, cart]
    }

    private func createAndPresentSlideMenu() {
        slideMenu = SlideMenuController(mainViewController: mainNavigation.navigationController,
                                        leftMenuViewController: leftMenu)
        window.rootViewController = slideMenu
        makeWindowKeyAndVisible()
    }

    private func setUpMainNavigationController() {
        guard let topViewController = mainNavigation.navigationController.topViewController else { return }
        setUpNavigationItems(in: topViewController)
        mainNavigation.navigationController.render(Constants.navigationBarRenderable)
    }

    private func setUpSlideMenuOptions() {
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.size.width * Constants.menuWidthRatio
        SlideMenuOptions.contentViewScale = Constants.contentViewScale
        SlideMenuOptions.contentViewDrag = true
    }

    private func makeWindowKeyAndVisible() {
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
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
        // (https://taiga.neoteric.eu/project/mpaprocki-vyrl-mobile/us/73?kanban-status=427)
        slideMenu.closeLeft()
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
