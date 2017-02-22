//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStorePresenting: class {
    func presentStore(for brand: Brand, animated: Bool)
}

final class BrandsNavigation: NavigationControlling {

    let navigationController: UINavigationController
    fileprivate let brandsFactory: BrandsControllerMaking.Type
    fileprivate let brandStoreFactory: BrandStoreMaking.Type

    init(brandsFactory: BrandsControllerMaking.Type,
         brandStoreFactory: BrandStoreMaking.Type,
         navigationController: UINavigationController) {
        self.brandStoreFactory = brandStoreFactory
        self.brandsFactory = brandsFactory
        self.navigationController = navigationController
        initializeNavigation()
    }

    private func initializeNavigation() {
        let mainViewController: BrandsViewController = brandsFactory.make(storePresenter: self)
        navigationController.viewControllers = [mainViewController]
    }
}

extension BrandsNavigation: BrandStorePresenting {
    func presentStore(for brand: Brand, animated: Bool = true) {
        let vc = brandStoreFactory.make(brand: brand)
        navigationController.pushViewController(vc, animated: animated)
    }
}
