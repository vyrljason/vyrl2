//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController
}

enum BrandStoreControllerFactory: BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController {
        let dataSource = BrandStoreDataSource(brand: brand)
        let interactor = BrandStoreInteractor(dataSource: dataSource)
        let viewController = BrandStoreViewController(interactor: interactor)
        return viewController
    }
}
