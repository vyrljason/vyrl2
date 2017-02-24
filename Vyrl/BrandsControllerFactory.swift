//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandsControllerMaking {
    static func make(storePresenter: BrandStorePresenting) -> BrandsViewController
}

protocol BrandsInteractorMaking {
    static func make() -> BrandsInteractor
}

enum BrandsInteractorFactory: BrandsInteractorMaking {

   private enum Constants {
        static let titleAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let descriptionAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let noDataTitle = NSLocalizedString("No brands", comment: "")
        static let networkingErrorTitle = NSLocalizedString("Something went wrong", comment: "")
        static let noDataDescription = NSLocalizedString("Sorry, there are no brands at the moment.", comment: "")
        static let networkingErrorDescription = NSLocalizedString("Pull down to refresh.", comment: "")
    }

    static func make() -> BrandsInteractor {
       let noBrands = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                           attributes: Constants.titleAttributes),
                                                 description: NSAttributedString(string: Constants.noDataDescription,
                                                                                 attributes: Constants.descriptionAttributes))
        let brandsError = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.networkingErrorTitle,
                                                                              attributes: Constants.titleAttributes),
                                                    description: NSAttributedString(string: Constants.networkingErrorDescription,
                                                                                    attributes: Constants.descriptionAttributes))

        let resource = Service<BrandsResourceMock>(resource: BrandsResourceMock(amount: 30))
        let service = BrandsService(resource: resource)
        let dataSource = BrandsDataSource(service: service)
        let modeMap: [EmptyCollectionMode : EmptyCollectionRenderable] = [ .error : brandsError, .noData : noBrands ]
        let emptyCollectionHandler = EmptyCollectionViewHandler(modeToRenderable: modeMap)
        return BrandsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
    }
}

enum BrandsControllerFactory: BrandsControllerMaking {
        interactor.brandStorePresenter = storePresenter
        let viewController = BrandsViewController(interactor: interactor)
        interactor.dataUpdateListener = viewController
        return viewController
    }
}