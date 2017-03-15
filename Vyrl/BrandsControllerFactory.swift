//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandsControllerMaking {
    static func make(storePresenter: BrandStorePresenting, interactor: BrandsInteracting & DataRefreshing) -> BrandsViewController
}

protocol BrandsInteractorMaking {
    static func make() -> BrandsInteractor
}

enum BrandsInteractorFactory: BrandsInteractorMaking {

   private enum Constants {
        static let titleAttributes: [String: Any] = StyleKit.noDataHeaderAttributes
        static let descriptionAttributes: [String: Any] = StyleKit.noDataDescriptionAttributes
        static let noDataTitle = NSLocalizedString("No brands", comment: "")
        static let networkingErrorTitle = NSLocalizedString("Something went wrong", comment: "")
        static let noDataDescription = NSLocalizedString("Sorry, there are no brands at the moment.", comment: "")
        static let networkingErrorDescription = NSLocalizedString("Pull down to refresh.", comment: "")
    }

    static func make() -> BrandsInteractor {
       let noBrands = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                           attributes: Constants.titleAttributes),
                                                 description: NSAttributedString(string: Constants.noDataDescription,
                                                                                 attributes: Constants.descriptionAttributes),
                                                 image: #imageLiteral(resourceName: "errorIllustration"))
        let brandsError = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.networkingErrorTitle,
                                                                              attributes: Constants.titleAttributes),
                                                    description: NSAttributedString(string: Constants.networkingErrorDescription,
                                                                                    attributes: Constants.descriptionAttributes),
                                                    image: #imageLiteral(resourceName: "errorIllustration"))

        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = ParameterizedService<BrandsResource>(resource: BrandsResource(controller: resourceController))
        let service = BrandsService(resource: resource)
        let dataSource = BrandsDataSource(service: service)
        let modeMap: [EmptyCollectionMode : EmptyCollectionRenderable] = [ .error: brandsError, .noData: noBrands ]
        let emptyCollectionHandler = EmptyCollectionViewHandler(modeToRenderable: modeMap)
        return BrandsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
    }
}

enum BrandsControllerFactory: BrandsControllerMaking {
    static func make(storePresenter: BrandStorePresenting, interactor: BrandsInteracting & DataRefreshing) -> BrandsViewController {
        interactor.brandStorePresenter = storePresenter
        let viewController = BrandsViewController(interactor: interactor)
        interactor.dataUpdateListener = viewController
        return viewController
    }
}
