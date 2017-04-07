//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Firebase

protocol MessagesControllerMaking {
    static func make(collab: Collab, presenter: ComposePresenting) -> MessagesViewController
}

final class MessagesViewControllerFactory: MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController {
        let databaseReference = ServiceLocator.chatDatabaseReference
        let chatCredentialsStorage = ChatCredentialsStorage()
        let resource = ServiceLocator.resourceConfigurator.resourceController
        let chatRoomUpdater = ChatRoomUpdater(chatDatabase: databaseReference)
        let orderStatusUpdater = OrderStatusUpdater(chatDatabase: databaseReference, chatCredentialsStorage: chatCredentialsStorage)
        let chatPresenceService = ChatPresenceService(chatDatabase: databaseReference, chatCredentialsStorage: chatCredentialsStorage)

        let postInstagramResource = PostInstagramResource(controller: resource)
        let influencerPostResourceAdapter = PostService<PostInstagramResource>(resource: postInstagramResource)
        let influencerPostUpdater = InstagramUpdateService(resource: influencerPostResourceAdapter)

        let collaborationStatus = CollabStatus(orderStatus: collab.chatRoom.orderStatus, contentStatus: collab.chatRoom.contentStatus)
        let dataSource = MessagesDataSource(collab: collab,
                                            collaborationStatus: collaborationStatus,
                                            chatRoomUpdater: chatRoomUpdater, orderStatusUpdater: orderStatusUpdater,
                                            chatPresenceService: chatPresenceService)
        let postMessageResource = PostMessageResource(controller: resource)
        let postService = PostService<PostMessageResource>(resource: postMessageResource)
        let messageSender = TextMessageService(resource: postService)
        let confirmDeliveryResource = ConfirmDeliveryResource(controller: resource)
        let deliveryResource = PostService<ConfirmDeliveryResource>(resource: confirmDeliveryResource)
        let deliveryService = ConfirmDeliveryService(resource: deliveryResource)
        let interactor = MessagesInteractor(dataSource: dataSource, collab: collab, messageSender: messageSender,
                                            deliveryService: deliveryService, influencerPostUpdater: influencerPostUpdater)
        interactor.composePresenter = presenter
        let viewController = MessagesViewController(interactor: interactor)
        viewController.navigationItem.title = collab.brandName
        dataSource.statusViewUpdater = viewController
        return viewController
    }
}
