//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandsControllerMaking {
    static func make(storePresenter: BrandStorePresenting) -> BrandsViewController
}

enum BrandsControllerFactory: BrandsControllerMaking {
    static func make(storePresenter: BrandStorePresenting) -> BrandsViewController {
        let resource = BrandsResourceMock(amount: 30)
        let service = BrandsService(resource: resource)
        let dataSource = BrandsDataSource(repository: service)
        let emptyCollectionHandler = EmptyCollectionViewHandler()
        let interactor = BrandsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
        interactor.brandStorePresenter = storePresenter
        let viewController = BrandsViewController(interactor: interactor)
        interactor.dataUpdateListener = viewController
        return viewController
    }
}
