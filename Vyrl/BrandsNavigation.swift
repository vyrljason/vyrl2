//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStorePresenting: class {
    func presentStore(for brand: Brand, animated: Bool)
}

protocol ProductDetailsPresenting: class {
    func presentProductDetails(for product: Product, animated: Bool)
}

final class BrandsNavigation: NavigationControlling {

    let navigationController: UINavigationController
    fileprivate let brandsFactory: BrandsControllerMaking.Type
    fileprivate let brandStoreFactory: BrandStoreMaking.Type
    fileprivate let productDetailsFactory: ProductDetailsMaking.Type
    fileprivate let brandsInteractor: BrandsInteracting & DataRefreshing

    init(brandsInteractor: BrandsInteracting & DataRefreshing,
         brandsFactory: BrandsControllerMaking.Type,
         brandStoreFactory: BrandStoreMaking.Type,
         productDetailsFactory: ProductDetailsMaking.Type,
         navigationController: UINavigationController) {
        self.brandsInteractor = brandsInteractor
        self.brandStoreFactory = brandStoreFactory
        self.brandsFactory = brandsFactory
        self.productDetailsFactory = productDetailsFactory
        self.navigationController = navigationController
        initializeNavigation()
    }

    private func initializeNavigation() {
        let mainViewController: BrandsViewController = brandsFactory.make(storePresenter: self,
                                                                          interactor: brandsInteractor)
        navigationController.viewControllers = [mainViewController]
    }
}

extension BrandsNavigation: BrandStorePresenting {
    func presentStore(for brand: Brand, animated: Bool = true) {
        let viewController = brandStoreFactory.make(brand: brand, presenter: self)
        navigationController.pushViewController(viewController, animated: animated)
    }
}

extension BrandsNavigation: ProductDetailsPresenting {
    func presentProductDetails(for product: Product, animated: Bool = true) {
        let viewController = productDetailsFactory.make(brand: product)
        navigationController.pushViewController(viewController, animated: animated)
    }
}
