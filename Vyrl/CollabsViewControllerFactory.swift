//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import FirebaseDatabase

fileprivate struct Constants {
    static let collabsNavigationTitle = NSLocalizedString("collabs.navigation.title", comment: "")
    static let noDataTitle = NSLocalizedString("collabs.placeholder.noDataTitle", comment: "")
    static let noDataDescription = NSLocalizedString("collabs.placeholder.noDataDescription", comment: "")
}

protocol CollabsControllerMaking {
    static func make(presenter: MessagesPresenting) -> CollabsViewController
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

    static func make(presenter: MessagesPresenting) -> CollabsViewController {
        let credentialsStorage = ChatCredentialsStorage()
        let databaseReference = ServiceLocator.chatDatabaseReference
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let brandsResource = ParameterizedService<BrandsResource>(resource: BrandsResource(controller: resourceController))
        let brandsService = BrandsService(resource: brandsResource)
        let service = CollabsService(chatDatabase: databaseReference, chatCredentialsStorage: credentialsStorage, brandsService: brandsService)
        let dataSource = CollabsDataSource(service: service)
        let emptyCollectionHandler = emptyCollectionViewHandler()
        let interactor = CollabsInteractor(dataSource: dataSource, emptyCollectionHandler: emptyCollectionHandler)
        let viewController = CollabsViewController(interactor: interactor)
        viewController.navigationItem.title = Constants.collabsNavigationTitle
        dataSource.selectionDelegate = interactor
        dataSource.collectionUpdateListener = interactor
        interactor.dataUpdateListener = viewController
        interactor.messagesPresenter = presenter
        return viewController
    }
}
