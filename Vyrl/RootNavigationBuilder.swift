//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class RootNavigationBuilder {

    private enum Constants {
        static let chatTitle = NSLocalizedString("CHAT", comment: "")
        static let cartTitle = NSLocalizedString("YOUR CART", comment: "")
    }

    var interactor: RootNavigationInteracting & NavigationDelegateHaving = RootNavigationInteractor()
    var mainNavigation: NavigationControlling = BrandsNavigation(brandsFactory: BrandsControllerFactory.self, brandStoreFactory: BrandStoreControllerFactory.self,
                                                            navigationController: UINavigationController())
    var cart: UIViewController = UIViewController()
    var chat: UIViewController = UIViewController()
    var window: WindowProtocol = UIWindow()
    var accountMaker: AccountViewControllerMaking.Type = AccountViewControllerFactory.self
    var leftMenuInteractor = LeftMenuInteractorFactory.make()
    lazy var leftMenu: UIViewController = { return LeftMenuViewController(interactor: self.leftMenuInteractor) }()

    func build() -> RootNavigation {

        chat.title = Constants.chatTitle    // FIXME: REMOVE
        cart.title = Constants.cartTitle    // FIXME: REMOVE
        chat.view.backgroundColor = .white  // FIXME: REMOVE
        cart.view.backgroundColor = .white  // FIXME: REMOVE

        let navigation = RootNavigation(interactor: interactor,
                                        leftMenu: leftMenu,
                                        mainNavigation: mainNavigation,
                                        cart: cart,
                                        chat: chat,
                                        accountMaker: accountMaker,
                                        window: window)
        leftMenuInteractor.delegate = navigation
        return navigation
    }
}
