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
        let databaseReference = ServiceLocator.chatDatabaseReference
        let chatCredentialsStorage = ChatCredentialsStorage()
        let resource = ServiceLocator.resourceConfigurator.resourceController
        let chatRoomUpdater = ChatRoomUpdater(chatDatabase: databaseReference)
        let orderStatusUpdater = OrderStatusUpdater(chatDatabase: databaseReference, chatCredentialsStorage: chatCredentialsStorage)
        let chatPresenceService = ChatPresenceService(chatDatabase: databaseReference, chatCredentialsStorage: chatCredentialsStorage)

        let influencerPostsResource = InfluencerPostsResource(controller: resource)
        let influencerPostsResourceAdapter = PostService<InfluencerPostsResource>(resource: influencerPostsResource)
        let influencerPostsService = InfluencerPostsService(resource: influencerPostsResourceAdapter)

        let postInstagramResource = PostInstagramResource(controller: resource)
        let influencerPostResourceAdapter = PostService<PostInstagramResource>(resource: postInstagramResource)
        let influencerPostUpdater = InstagramUpdateService(resource: influencerPostResourceAdapter)

        let collaborationStatus = CollabStatus(orderStatus: collab.chatRoom.orderStatus, contentStatus: collab.chatRoom.contentStatus)
        let dataSource = MessagesDataSource(collab: collab,
                                            collaborationStatus: collaborationStatus,
                                            chatRoomUpdater: chatRoomUpdater, orderStatusUpdater: orderStatusUpdater,
                                            chatPresenceService: chatPresenceService,
                                            influencerPostUpdater: influencerPostUpdater,
                                            influencerPostsService: influencerPostsService)
        let postMessageResource = PostMessageResource(controller: resource)
        let postService = PostService<PostMessageResource>(resource: postMessageResource)
        let messageSender = TextMessageService(resource: postService)
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
