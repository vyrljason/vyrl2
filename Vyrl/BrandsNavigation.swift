//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStorePresenting: class {
    func presentStore(for brand: Brand, modally: Bool, animated: Bool)
}

final class BrandsNavigation: NavigationHaving {

    private(set) var navigationController: UINavigationController = UINavigationController()
    fileprivate let brandsFactory: BrandsControllerMaking.Type
    fileprivate let brandStoreFactory: BrandStoreMaking.Type

    init(brandsFactory: BrandsControllerMaking.Type,
         brandStoreFactory: BrandStoreMaking.Type) {
        self.brandStoreFactory = brandStoreFactory
        self.brandsFactory = brandsFactory
        initializeNavigation()
    }

    private func initializeNavigation() {
        let mainViewController: BrandsViewController = brandsFactory.make(storePresenter: self)
        navigationController = UINavigationController(rootViewController: mainViewController)
    }

    func resetNavigation() {
        navigationController.popViewController(animated: true)
    }

    func dismissModalFlow() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension BrandsNavigation: BrandStorePresenting {
    func presentStore(for brand: Brand, modally: Bool = false, animated: Bool = true) {
        let vc = brandStoreFactory.make(brand: brand)
        if modally {
            navigationController.present(vc, animated: animated, completion: nil)
        } else {
            navigationController.pushViewController(vc, animated: animated)
        }
    }
}
