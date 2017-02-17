//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum InitialNavigationFactory {
    static func make(mainView: UIViewController = BrandsViewControllerFactory.make(),
                     leftMenu: UIViewController = LeftMenuViewController(),
                     cart: UIViewController = UIViewController(),
                     chat: UIViewController = UIViewController(),
                     window: WindowProtocol = UIWindow()) -> InitialNavigation {

        chat.title = NSLocalizedString("CHAT", comment: "")
        cart.title = NSLocalizedString("YOUR CART", comment: "")

        return InitialNavigation(mainView: mainView,
                                 leftMenu: leftMenu,
                                 cart: cart,
                                 chat: chat,
                                 window: window)
    }
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
    }

    private let window: WindowProtocol
    private var slideMenu: SlideMenuController!
    private let mainView: UIViewController
    private var mainNavigation: UINavigationController!
    private let leftMenu: UIViewController
    private let cart: UIViewController
    private let chat: UIViewController

    // swiftlint:disable function_parameter_count
    init(mainView: UIViewController,
         leftMenu: UIViewController,
         cart: UIViewController,
         chat: UIViewController,
         window: WindowProtocol) {
        self.mainView = mainView
        self.leftMenu = leftMenu
        self.cart = cart
        self.chat = chat
        self.window = window
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
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu",
                                                                          style: .plain,
                                                                          target: self,
                                                                          action: #selector(showLeftMenu))
        let chat = UIBarButtonItem(title: "Chat",
                                   style: .plain,
                                   target: self,
                                   action: #selector(showChat))

        let cart = UIBarButtonItem(title: "Cart",
                                   style: .plain,
                                   target: self,
                                   action: #selector(showCart))

        viewController.navigationItem.rightBarButtonItems = [chat, cart]
    }

    private func createAndPresentSlideMenu() {
        slideMenu = SlideMenuController(mainViewController: mainNavigation,
                                        leftMenuViewController: leftMenu)
        window.rootViewController = slideMenu
        makeWindowKeyAndVisible()
    }

    private func setUpMainNavigationController() {
        mainNavigation = UINavigationController(rootViewController: mainView)

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

    @objc private func showLeftMenu() {
        slideMenu.openLeft()
    }

    @objc private func showCart() {
        presentModally(cart)
    }

    @objc private func showChat() {
        presentModally(chat)
    }

    private func presentModally(_ viewController: UIViewController) {
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.view.backgroundColor = .white
        let close = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""),
                                    style: .done,
                                    target: self,
                                    action: #selector(dismissModal))
        viewController.navigationItem.leftBarButtonItem = close
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.render(Constants.navigationBarRenderable)
        mainNavigation.present(navigation, animated: true, completion: nil)
    }

    @objc private func dismissModal() {
        mainNavigation.dismiss(animated: true, completion: nil)
    }
}
