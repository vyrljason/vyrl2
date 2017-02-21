//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class InitialNavigationBuilder {

    private enum Constants {
        static let chatTitle = NSLocalizedString("CHAT", comment: "")
        static let cartTitle = NSLocalizedString("YOUR CART", comment: "")
    }

    private let brandsNavigation: BrandsFlowNavigating

    init(brandsNavigation: BrandsFlowNavigating = BrandsNavigation(brandsFactory: BrandsControllerFactory.self, brandStoreFactory: BrandStoreControllerFactory.self)) {
        self.brandsNavigation = brandsNavigation
        mainNavigation = brandsNavigation.navigationController
    }

    var interactor: InitialNavigationInteracting & NavigationDelegateHaving = InitialNavigationInteractor()
    private(set) var mainNavigation: UINavigationController
    var leftMenuInteractor: LeftMenuInteractor = LeftMenuInteractor()
    var cart: UIViewController = UIViewController()
    var chat: UIViewController = UIViewController()
    var window: WindowProtocol = UIWindow()
    lazy var leftMenu: UIViewController = {
        return LeftMenuViewController(interactor: self.leftMenuInteractor)
    }()

    func build() -> InitialNavigation {

        chat.title = Constants.chatTitle
        cart.title = Constants.cartTitle

        let navigation = InitialNavigation(interactor: interactor,
                                           mainNavigation: mainNavigation,
                                           leftMenu: leftMenu,
                                           cart: cart,
                                           chat: chat,
                                           window: window)

        leftMenuInteractor.delegate = navigation

        return navigation
    }
}
