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
    static func makeEmptyTableHandler() -> EmptyTableViewHandler {
        let noData = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                         attributes: StyleKit.noDataHeaderAttributes),
                                               description: NSAttributedString(string: Constants.noDataDescription,
                                                                               attributes: StyleKit.noDataDescriptionAttributes),
                                               image: #imageLiteral(resourceName: "chatEmpty"))
        let emptyTableHandler = EmptyTableViewHandler(modeToRenderable: [ .noData: noData ])
        return emptyTableHandler
        
    }
    static func make(chatNavigation: ChatNavigating) -> CollabsViewController {
        let emptyTableHandler = makeEmptyTableHandler()
        let interactor = CollabsInteractor(emptyTableHandler: emptyTableHandler)
        let collabs = CollabsViewController(interactor: interactor)
        collabs.navigationItem.title = Constants.collabsNavigationTitle
        return collabs
    }
}
