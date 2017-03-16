//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let collabsNavigationTitle = NSLocalizedString("collabs.navigation.title", comment: "")
    static let noDataTitle = NSLocalizedString("collabs.placeholder.noDataTitle", comment: "")
    static let noDataDescription = NSLocalizedString("collabs.placeholder.noDataDescription", comment: "")
}

protocol CollabsControllerMaking {
    static func make(chatNavigation: ChatNavigating) -> CollabsViewController
}

final class CollabsViewControllerFactory: CollabsControllerMaking {
    static func emptyCollectionViewHandler() -> EmptyCollectionViewHandling {
        let noData = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                         attributes: StyleKit.noDataHeaderAttributes),
                                               description: NSAttributedString(string: Constants.noDataDescription,
                                                                               attributes: StyleKit.noDataDescriptionAttributes),
                                               image: #imageLiteral(resourceName: "chatEmpty"))
        let handler = EmptyCollectionViewHandler(modeToRenderable: [ .noData: noData ])
        return handler
    }

    static func make(chatNavigation: ChatNavigating) -> CollabsViewController {
        let resource = Service<CollabsResourceMock>(resource: CollabsResourceMock(amount: 15))
        let service = CollabsService(resource: resource)
        let dataSource = CollabsDataSource(service: service)

        let emptyCollectionHandler = emptyCollectionViewHandler()
        let interactor = CollabsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
        let viewController = CollabsViewController(interactor: interactor)
        viewController.navigationItem.title = Constants.collabsNavigationTitle
        dataSource.collectionViewControllingDelegate = interactor
        dataSource.selectionDelegate = interactor
        interactor.dataUpdateListener = viewController
        return viewController
    }
}
