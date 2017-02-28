//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class CartViewControllerFactory {

    private enum Constants {
        static let titleAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let descriptionAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let noDataTitle = NSLocalizedString("No products in cart", comment: "")
        static let noDataDescription = NSLocalizedString("Add some products", comment: "")
        static let networkingErrorTitle = NSLocalizedString("Something went wrong", comment: "")
        static let networkingErrorDescription = NSLocalizedString("Please contact the administrator", comment: "")
    }

    static func make() -> CartViewController {

        let noData = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                         attributes: Constants.titleAttributes),
                                               description: NSAttributedString(string: Constants.noDataDescription,
                                                                               attributes: Constants.descriptionAttributes))
        let error = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.networkingErrorTitle,
                                                                        attributes: Constants.titleAttributes),
                                              description: NSAttributedString(string: Constants.networkingErrorDescription,
                                                                              attributes: Constants.descriptionAttributes))
        let storage = CartStorage()
        let dataSource = CartDataSource(cartStorage: storage)
        let emptyCollectionHandler = EmptyCollectionViewHandler(modeToRenderable: [ .error : error, .noData : noData ])
        let interactor = CartInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
        let viewController = CartViewController(interactor: interactor)
        return viewController
    }
}
