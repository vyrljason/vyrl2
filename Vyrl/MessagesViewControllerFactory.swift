//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Firebase

protocol MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController
}

final class MessagesViewControllerFactory: MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController {
        let databaseReference = ServiceLocator.chatDatabaseReference
        let chatCredentialsStorage = ChatCredentialsStorage()
        let resource = ServiceLocator.resourceConfigurator.resourceController
        let chatRoomUpdater = ChatRoomUpdater(chatDatabase: databaseReference)
        let orderStatusUpdater = OrderStatusUpdater(chatDatabase: databaseReference, chatCredentialsStorage: chatCredentialsStorage)
        let initialStatus = CollabStatus(orderStatus: collab.chatRoom.status)
        let dataSource = MessagesDataSource(collab: collab, status: initialStatus,
                                            chatRoomUpdater: chatRoomUpdater, orderStatusUpdater: orderStatusUpdater)
        let postMessageResource = PostMessageResource(controller: resource)
        let postService = PostService<PostMessageResource>(resource: postMessageResource)
        let messageSender = TextMessageService(resource: postService)
        let confirmDeliveryResource = ConfirmDeliveryResource(controller: resource)
        let deliveryResource = PostService<ConfirmDeliveryResource>(resource: confirmDeliveryResource)
        let deliveryService = ConfirmDeliveryService(resource: deliveryResource)
        let interactor = MessagesInteractor(dataSource: dataSource, collab: collab, messageSender: messageSender, deliveryService: deliveryService)
        let viewController = MessagesViewController(interactor: interactor)
        viewController.navigationItem.title = collab.brandName
        return viewController
    }
}
