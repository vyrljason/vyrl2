//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum BrandsViewControllerFactory {
    private enum Constants {
        static let titleAttributes: [String: Any] = StyleKit.noDataHeaderAttributes
        static let descriptionAttributes: [String: Any] = StyleKit.noDataDescriptionAttributes
        static let noDataTitle = NSLocalizedString("cart.noProducts.title", comment: "")
        static let noDataDescription = NSLocalizedString("cart.noProducts.description", comment: "")
        static let networkingErrorTitle = NSLocalizedString("cart.error.title", comment: "")
        static let networkingErrorDescription = NSLocalizedString("cart.error.description", comment: "")
    }

    static func make() -> BrandsViewController {
        let noData = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                         attributes: Constants.titleAttributes),
                                               description: NSAttributedString(string: Constants.noDataDescription,
                                                                               attributes: Constants.descriptionAttributes),
                                               image: #imageLiteral(resourceName: "errorIllustration"))
        let error = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.networkingErrorTitle,
                                                                        attributes: Constants.titleAttributes),
                                              description: NSAttributedString(string: Constants.networkingErrorDescription,
                                                                              attributes: Constants.descriptionAttributes),
                                              image: #imageLiteral(resourceName: "errorIllustration"))
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = ParameterizedService<BrandsResource>(resource: BrandsResource(controller: resourceController))
        let service = BrandsService(resource: resource)
        let dataSource = BrandsDataSource(service: service)
        let emptyCollectionHandler = EmptyCollectionViewHandler(modeToRenderable: [ .error: error, .noData: noData ])
        let interactor = BrandsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
        let viewController = BrandsViewController(interactor: interactor)
        interactor.dataUpdateListener = viewController
        return viewController
    }
}
