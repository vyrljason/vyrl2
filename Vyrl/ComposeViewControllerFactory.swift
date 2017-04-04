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
        let imageUploader = ImageUploadResource(controller: resource)
        let imageToDataConverter = ImageToDataConverter()
        let postService = PostService<PostMessageResource>(resource: postMessageResource)
        let messageSender = ImageMessageService(postService: postService, imageUploader: imageUploader, imageConverter: imageToDataConverter)
        let interactor = ComposeInteractor(collab: collab, messageSender: messageSender)
        interactor.composeCloser = closer
        return ComposeViewController(interactor: interactor)
    }
}
