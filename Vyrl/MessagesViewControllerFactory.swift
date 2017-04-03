//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Firebase

protocol MessagesControllerMaking {
    static func make(collab: Collab, presenter: ComposePresenting) -> MessagesViewController
}

final class MessagesViewControllerFactory: MessagesControllerMaking {
    static func make(collab: Collab, presenter: ComposePresenting) -> MessagesViewController {
        let databaseReference = FIRDatabase.database().reference()
        let service = MessagesService(chatDatabase: databaseReference)
        let dataSource = MessagesDataSource(service: service, collab: collab)
        let resource = ServiceLocator.resourceConfigurator.resourceController
        let postMessageResource = PostMessageResource(controller: resource)
        let postService = PostService<PostMessageResource>(resource: postMessageResource)
        let messageSender = PostMessageService(resource: postService)
        let confirmDeliveryResource = ConfirmDeliveryResource(controller: resource)
        let deliveryResource = PostService<ConfirmDeliveryResource>(resource: confirmDeliveryResource)
        let deliveryService = ConfirmDeliveryService(resource: deliveryResource)
        let interactor = MessagesInteractor(dataSource: dataSource, collab: collab, messageSender: messageSender, deliveryService: deliveryService)
        interactor.composePresenter = presenter
        let viewController = MessagesViewController(interactor: interactor)
        viewController.navigationItem.title = collab.brandName
        return viewController
    }
}
