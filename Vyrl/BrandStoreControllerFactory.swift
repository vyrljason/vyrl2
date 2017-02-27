//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController
}

enum BrandStoreControllerFactory: BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController {
        let interactor = BrandStoreInteractor()
        let viewController = BrandStoreViewController(interactor: interactor)
        return viewController
    }
}
