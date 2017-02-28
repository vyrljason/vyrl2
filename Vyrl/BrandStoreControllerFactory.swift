//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController
}

enum BrandStoreControllerFactory: BrandStoreMaking {
    static func make(brand: Brand) -> BrandStoreViewController {
        let resource = Service<ProductsResourceMock>(resource: ProductsResourceMock(amount: 15))
        let service = BrandStoreService(resource: resource)
        let flowHandler = BrandStoreFlowLayoutHandler()
        let dataSource = BrandStoreDataSource(brand: brand, service: service, flowLayoutHandler: flowHandler)
        let interactor = BrandStoreInteractor(dataSource: dataSource)
        let viewController = BrandStoreViewController(interactor: interactor)
        return viewController
    }
}
