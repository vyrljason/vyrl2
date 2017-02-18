//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum InitialNavigationFactory {

    private enum Constants {
        static let chatTitle = NSLocalizedString("CHAT", comment: "")
        static let cartTitle = NSLocalizedString("YOUR CART", comment: "")
    }

    static func make(interactor: InitialNavigationInteracting & NavigationDelegateHaving = InitialNavigationInteractor(),
                     mainView: UIViewController = BrandsViewControllerFactory.make(),
                     leftMenu: UIViewController = LeftMenuViewController(),
                     cart: UIViewController = UIViewController(),
                     chat: UIViewController = UIViewController(),
                     window: WindowProtocol = UIWindow()) -> InitialNavigation {

        chat.title = Constants.chatTitle
        cart.title = Constants.cartTitle

        return InitialNavigation(interactor: interactor,
                                 mainView: mainView,
                                 leftMenu: leftMenu,
                                 cart: cart,
                                 chat: chat,
                                 window: window)
    }
}
