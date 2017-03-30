//
//  MessagesViewControllerFactory.swift
//  Vyrl
//
//  Created by Wojciech Stasiński on 20/03/2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Firebase

protocol MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController
}

final class MessagesViewControllerFactory: MessagesControllerMaking {
    static func make(collab: Collab) -> MessagesViewController {
        let databaseReference = FIRDatabase.database().reference()
        let service = MessagesService(chatDatabase: databaseReference)
        let dataSource = MessagesDataSource(service: service, collab: collab)
        let resource = ServiceLocator.resourceConfigurator.resourceController
        let postMessageResource = PostMessageResource(controller: resource)
        let postService = PostService<PostMessageResource>(resource: postMessageResource)
        let messageSender = PostMessageService(resource: postService)
        let interactor = MessagesInteractor(dataSource: dataSource, collab: collab, messageSender: messageSender)
        let viewController = MessagesViewController(interactor: interactor)
        viewController.navigationItem.title = collab.brandName
        return viewController
    }
}
