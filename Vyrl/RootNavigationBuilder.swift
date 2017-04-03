//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class RootNavigationBuilder {

    private enum Constants {
        static let chatTitle = NSLocalizedString("chat.title", comment: "")
    }

    var interactor: RootNavigationInteracting & NavigationDelegateHaving = RootNavigationInteractor()
    var brandsInteractor = BrandsInteractorFactory.make()
    lazy var mainNavigation: NavigationControlling & BrandsNavigating = { BrandsNavigation(brandsInteractor: self.brandsInteractor,
                                                                        brandsFactory: BrandsControllerFactory.self,
                                                                        brandStoreFactory: BrandStoreControllerFactory.self,
                                                                        productDetailsFactory: ProductDetailsControllerFactory.self,
                                                                        navigationController: UINavigationController()) }()
    var cart: CartNavigating = CartNavigationBuilder().build()
    var chat: ChatNavigating = ChatNavigationBuilder().build()
    var window: WindowProtocol = UIWindow()
    var accountMaker: AccountViewControllerMaking.Type = AccountViewControllerFactory.self
    var leftMenuInteractor = LeftMenuInteractorFactory.make()
    var loginControllerMaker: LoginControllerMaking.Type = LoginControllerFactory.self
    lazy var leftMenu: UIViewController = { return LeftMenuViewController(interactor: self.leftMenuInteractor) }()
    var credentialsProvider: APICredentialsProviding = APICredentialsProvider(storage: CredentialsStorage())
    var cartStorage: CartStoring = ServiceLocator.cartStorage
    var notificationObserver: NotificationObserving = NotificationCenter.default

    func build() -> RootNavigation {

        let navigation = RootNavigation(interactor: interactor,
                                        leftMenu: leftMenu,
                                        mainNavigation: mainNavigation,
                                        cart: cart,
                                        chat: chat,
                                        accountMaker: accountMaker,
                                        window: window,
                                        credentialsProvider: credentialsProvider,
                                        loginControllerMaker: loginControllerMaker,
                                        notificationObserver: notificationObserver,
                                        cartStorage: cartStorage)
        leftMenuInteractor.delegate = navigation
        navigation.brandsFiltering = brandsInteractor
        mainNavigation.mainNavigationDelegate = navigation
        return navigation
    }
}
