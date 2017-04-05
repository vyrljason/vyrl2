//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ComposeControllerMaking {
    static func make(collab: Collab, closer: ComposeClosing) -> ComposeViewController
}

enum ComposeViewControllerFactory: ComposeControllerMaking {
    static func make(collab: Collab, closer: ComposeClosing) -> ComposeViewController {
        let resource = ServiceLocator.resourceConfigurator.resourceController
        let postMessageResource = PostMessageResource(controller: resource)
        let postImageResource = PostImageResource(controller: resource)
        let imageUploader = ImageUploadResource(controller: resource)
        let imageToDataConverter = ImageToDataConverter()
        let chatPostService = PostService<PostMessageResource>(resource: postMessageResource)
        let imagePostService = PostService<PostImageResource>(resource: postImageResource)
        let messageSender = ImageMessageService(chatPostService: chatPostService, imagePostService: imagePostService, imageUploader: imageUploader, imageConverter: imageToDataConverter)
        let interactor = ComposeInteractor(collab: collab, messageSender: messageSender)
        interactor.composeCloser = closer
        return ComposeViewController(interactor: interactor)
    }
}
