//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum BrandsViewControllerFactory {
    static func make() -> BrandsViewController {
        let resource = BrandsResourceMock(amount: 30)
        let service = BrandsService(resource: resource)
        let dataSource = BrandsDataSource(repository: service)
        let interactor = BrandsInteractor(dataSource: dataSource)
        let viewController = BrandsViewController(interactor: interactor)
        return viewController
    }
}
