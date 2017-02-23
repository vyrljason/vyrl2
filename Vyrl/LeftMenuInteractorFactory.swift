//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum LeftMenuInteractorFactory {
    static func make() -> LeftMenuInteractor {
        let resource = Service<CategoriesResourceMock>(resource: CategoriesResourceMock())
        let service = CategoriesService(resource: resource)
        let categoriesDataSource: CategoriesDataSource = CategoriesDataSource(service: service,
                                                                              emptyTableHandler: EmptyCollectionViewHandler())
        return LeftMenuInteractor(dataSource: categoriesDataSource)
    }
}
