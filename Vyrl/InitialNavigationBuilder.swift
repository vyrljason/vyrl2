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
    var mainNavigation: UINavigationController = UINavigationController()
    var leftMenuInteractor: LeftMenuInteractor = LeftMenuInteractor()
    var cart: UIViewController = UIViewController()
    var chat: UIViewController = UIViewController()
    var window: WindowProtocol = UIWindow()
    var repository = Service<CategoriesResourceMock>(resource: CategoriesResourceMock())

    func build() -> InitialNavigation {

        chat.title = Constants.chatTitle
        cart.title = Constants.cartTitle

        let categoriesDataSource: CategoriesDataSource = CategoriesDataSource(repository: repository,
                                                                              emptyTableHandler: EmptyCollectionViewHandler())
        let leftMenuInteractor: LeftMenuInteractor = LeftMenuInteractor(dataSource: categoriesDataSource)
        let leftMenu: UIViewController = LeftMenuViewController(interactor: leftMenuInteractor)

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
