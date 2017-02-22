//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class InitialNavigationBuilder {

    private enum Constants {
        static let chatTitle = NSLocalizedString("CHAT", comment: "")
        static let cartTitle = NSLocalizedString("YOUR CART", comment: "")
    }

    var interactor: InitialNavigationInteracting & NavigationDelegateHaving = InitialNavigationInteractor()
    var mainNavigation: NavigationControlling = BrandsNavigation(brandsFactory: BrandsControllerFactory.self, brandStoreFactory: BrandStoreControllerFactory.self,
                                                            navigationController: UINavigationController())
    var cart: UIViewController = UIViewController()
    var chat: UIViewController = UIViewController()
    var window: WindowProtocol = UIWindow()
    var leftMenuInteractor = LeftMenuInteractorFactory.make()
    lazy var leftMenu: UIViewController = { return LeftMenuViewController(interactor: self.leftMenuInteractor) }()

    func build() -> InitialNavigation {

        chat.title = Constants.chatTitle    // FIXME: REMOVE
        cart.title = Constants.cartTitle    // FIXME: REMOVE
        chat.view.backgroundColor = .white  // FIXME: REMOVE
        cart.view.backgroundColor = .white  // FIXME: REMOVE

        let navigation = InitialNavigation(interactor: interactor,
                                           leftMenu: leftMenu,
                                           mainNavigation: mainNavigation,
                                           cart: cart,
                                           chat: chat,
                                           window: window)
        leftMenuInteractor.delegate = navigation
        return navigation
    }
}
