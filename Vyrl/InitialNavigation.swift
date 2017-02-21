//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

protocol InitialNavigationControlling: class {
    func showMenu()
    func showChat()
    func showCart()
    func dismissModal()
}

protocol HomeScreenPresenting: class {
    func showHome()
}

final class InitialNavigation {

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

    private let window: WindowProtocol
    fileprivate var slideMenu: SlideMenuController!
    private let mainView: UIViewController
    fileprivate var mainNavigation: UINavigationController!
    private let leftMenu: UIViewController
    fileprivate let cart: UIViewController
    fileprivate let chat: UIViewController
    private let interactor: InitialNavigationInteracting & NavigationDelegateHaving

    // swiftlint:disable function_parameter_count
    init(interactor: InitialNavigationInteracting & NavigationDelegateHaving,
         mainView: UIViewController,
         mainNavigation: UINavigationController,
         leftMenu: UIViewController,
         cart: UIViewController,
         chat: UIViewController,
         window: WindowProtocol) {
        self.interactor = interactor
        self.mainView = mainView
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
        setUpNavigationItems(in: mainView)
        setUpMainNavigationController()
        createAndPresentSlideMenu()
    }
    private func setUpNavigationItems(in viewController: UIViewController) {
        viewController.render(NavigationItemRenderable(titleImage: Constants.titleImage))

        // This is temporary - icon will be used.
        let menuButton = UIBarButtonItem(title: "Menu",
                                         style: .plain,
                                         target: interactor,
                                         action: #selector(InitialNavigationInteracting.didTapMenu))

        viewController.navigationItem.leftBarButtonItem = menuButton

        // This is temporary - icon will be used.
        let chat = UIBarButtonItem(title: "Chat",
                                   style: .plain,
                                   target: interactor,
                                   action: #selector(InitialNavigationInteracting.didTapChat))

        // This is temporary - icon will be used.
        let cart = UIBarButtonItem(title: "Cart",
                                   style: .plain,
                                   target: interactor,
                                   action: #selector(InitialNavigationInteracting.didTapCart))

        viewController.navigationItem.rightBarButtonItems = [chat, cart]
    }

    private func createAndPresentSlideMenu() {
        slideMenu = SlideMenuController(mainViewController: mainNavigation,
                                        leftMenuViewController: leftMenu)
        window.rootViewController = slideMenu
        makeWindowKeyAndVisible()
    }

    private func setUpMainNavigationController() {
        mainNavigation.viewControllers = [mainView]
        mainNavigation.render(Constants.navigationBarRenderable)
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
                                    action: #selector(InitialNavigationInteracting.didTapClose))
        viewController.navigationItem.leftBarButtonItem = close
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.render(Constants.navigationBarRenderable)
        mainNavigation.present(navigation, animated: true, completion: nil)
    }
}

extension InitialNavigation: HomeScreenPresenting {
    func showHome() {
        mainNavigation.popToRootViewController(animated: true)
        slideMenu.closeLeft()
    }
}

extension InitialNavigation: InitialNavigationControlling {
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
        mainNavigation.dismiss(animated: true, completion: nil)
    }
}
