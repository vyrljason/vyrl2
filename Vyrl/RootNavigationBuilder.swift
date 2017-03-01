//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class RootNavigationBuilder {

    private enum Constants {
        static let chatTitle = NSLocalizedString("CHAT", comment: "")
    }

    var interactor: RootNavigationInteracting & NavigationDelegateHaving = RootNavigationInteractor()
    var brandsInteractor = BrandsInteractorFactory.make()
    lazy var mainNavigation: NavigationControlling = { BrandsNavigation(brandsInteractor: self.brandsInteractor,
                                                                        brandsFactory: BrandsControllerFactory.self,
                                                                        brandStoreFactory: BrandStoreControllerFactory.self,
                                                                        productDetailsFactory: ProductDetailsControllerFactory.self,
                                                                        navigationController: UINavigationController()) }()
    var cart: UIViewController = CartViewControllerFactory.make()
    var chat: UIViewController = UIViewController()
    var window: WindowProtocol = UIWindow()
    var accountMaker: AccountViewControllerMaking.Type = AccountViewControllerFactory.self
    var leftMenuInteractor = LeftMenuInteractorFactory.make()
    var loginControllerMaker: LoginControllerMaking.Type = LoginControllerFactory.self
    lazy var leftMenu: UIViewController = { return LeftMenuViewController(interactor: self.leftMenuInteractor) }()
    var credentialsProvider: APICredentialsProviding = APICredentialsProvider(storage: CredentialsStorage())

    func build() -> RootNavigation {

        chat.title = Constants.chatTitle    // FIXME: REMOVE
        chat.view.backgroundColor = .white  // FIXME: REMOVE

        let navigation = RootNavigation(interactor: interactor,
                                        leftMenu: leftMenu,
                                        mainNavigation: mainNavigation,
                                        cart: cart,
                                        chat: chat,
                                        accountMaker: accountMaker,
                                        window: window,
                                        credentialsProvider: credentialsProvider,
                                        loginControllerMaker: loginControllerMaker)
        leftMenuInteractor.delegate = navigation
        navigation.brandsFiltering = brandsInteractor
        return navigation
    }
}
