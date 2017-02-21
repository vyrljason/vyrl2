//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandsFlowNavigating {
    var navigationController: UINavigationController { get }
    func resetNavigation()
}

protocol BrandStorePresenting {
    func presentStore(for brand: Brand, modally: Bool, animated: Bool)
}

final class BrandsNavigation: BrandsFlowNavigating {

    let navigationController: UINavigationController
    fileprivate let brandsFactory: BrandsControllerMaking.Type
    fileprivate let brandStoreFactory: BrandStoreMaking.Type

    init(brandsFactory: BrandsControllerMaking.Type,
         brandStoreFactory: BrandStoreMaking.Type) {
        self.brandStoreFactory = brandStoreFactory
        self.brandsFactory = brandsFactory
        navigationController = UINavigationController(rootViewController: self.brandsFactory.make())
    }

    func resetNavigation() {
        navigationController.popViewController(animated: true)
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
