//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartControllerMaking {
    static func make(cartNavigation: CartNavigating) -> CartViewController
}

final class CartViewControllerFactory: CartControllerMaking {

    private enum Constants {
        static let titleAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let descriptionAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let noDataTitle = NSLocalizedString("cart.noProducts.title", comment: "")
        static let noDataDescription = NSLocalizedString("cart.noProducts.description", comment: "")
        static let networkingErrorTitle = NSLocalizedString("cart.error.title", comment: "")
        static let networkingErrorDescription = NSLocalizedString("cart.error.description", comment: "")
    }

    static func make(cartNavigation: CartNavigating) -> CartViewController {

        let noData = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                         attributes: Constants.titleAttributes),
                                               description: NSAttributedString(string: Constants.noDataDescription,
                                                                               attributes: Constants.descriptionAttributes))
        let error = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.networkingErrorTitle,
                                                                        attributes: Constants.titleAttributes),
                                              description: NSAttributedString(string: Constants.networkingErrorDescription,
                                                                              attributes: Constants.descriptionAttributes))
        let storage = ServiceLocator.cartStorage
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = ParameterizedService<ProductsResource>(resource: ProductsResource(controller: resourceController))
        let service = ProductsService(resource: resource)
        let dataSource = CartDataSource(cartStorage: storage, service: service)
        let emptyTablenHandler = EmptyTableViewHandler(modeToRenderable: [ .error: error, .noData: noData ])
        let interactor = CartInteractor(dataSource: dataSource, emptyTableHandler: emptyTablenHandler)
        interactor.cartNavigation = cartNavigation
        let viewController = CartViewController(interactor: interactor)
        return viewController
    }
}
