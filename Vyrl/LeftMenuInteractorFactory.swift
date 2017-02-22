//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum LeftMenuInteractorFactory {
    static func make() -> LeftMenuInteractor {
        let repository = Service<CategoriesResourceMock>(resource: CategoriesResourceMock())
        let categoriesDataSource: CategoriesDataSource = CategoriesDataSource(repository: repository,
                                                                              emptyTableHandler: EmptyCollectionViewHandler())
        return LeftMenuInteractor(dataSource: categoriesDataSource)
    }
}
