//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let collabsNavigationTitle = NSLocalizedString("Collabs", comment: "")
    static let noDataTitle = NSLocalizedString("Hey", comment: "")
    static let noDataDescription = NSLocalizedString("You don't have any active collaborations yet. Hit \"close\" at the top of the screen to start looking through brands to work with.", comment: "")
}

protocol CollabsControllerMaking {
    static func make(chatNavigation: ChatNavigating) -> CollabsViewController
}

final class CollabsViewControllerFactory: CollabsControllerMaking {
    static private func makeEmptyTableHandler() -> EmptyTableViewHandler {
        let noData = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                         attributes: StyleKit.noDataHeaderAttributes),
                                               description: NSAttributedString(string: Constants.noDataDescription,
                                                                               attributes: StyleKit.noDataDescriptionAttributes),
                                               imageName: "chatEmpty")
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
