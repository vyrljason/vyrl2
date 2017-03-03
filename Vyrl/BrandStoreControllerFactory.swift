//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol BrandStoreMaking {
    static func make(brand: Brand, presenter: ProductDetailsPresenting) -> BrandStoreViewController
}

enum BrandStoreControllerFactory: BrandStoreMaking {
    static func make(brand: Brand, presenter: ProductDetailsPresenting) -> BrandStoreViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = ParameterizedService<ProductsResource>(resource: ProductsResource(controller: resourceController))
        let service = BrandStoreService(resource: resource)
        let flowHandler = BrandStoreFlowLayoutHandler()
        let dataSource = BrandStoreDataSource(brand: brand, service: service, flowLayoutHandler: flowHandler)
        let interactor = BrandStoreInteractor(dataSource: dataSource)
        interactor.productDetailsPresenter = presenter
        let viewController = BrandStoreViewController(interactor: interactor)
        return viewController
    }
}
