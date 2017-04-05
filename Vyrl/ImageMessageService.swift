//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum ImageMessageError: Error {
    case imageConversion
    case imageUpload
    case imagePost
    case chatPost
}

protocol ImageMessageSending {
    func send(message: String, withImage image: UIImage, toCollab collab: Collab, completion: @escaping (Result<Void, ImageMessageError>) -> Void)
}

final class ImageMessageService: ImageMessageSending {
    private let imageUploader: ImageDataUploading
    private let imageConverter: ImageToDataConverting
    private let chatPostService: PostService<PostMessageResource>
    private let imagePostService: PostService<PostImageResource>

    init(chatPostService: PostService<PostMessageResource>,
         imagePostService: PostService<PostImageResource>,
         imageUploader: ImageDataUploading,
         imageConverter: ImageToDataConverting) {
        self.imageUploader = imageUploader
        self.imageConverter = imageConverter
        self.chatPostService = chatPostService
        self.imagePostService = imagePostService
    }

    func send(message: String, withImage image: UIImage, toCollab collab: Collab, completion: @escaping (Result<Void, ImageMessageError>) -> Void) {
        guard let data = imageConverter.convert(image: image) else {
            completion(.failure(.imageConversion))
            return
        }
        imageUploader.upload(imageData: data) { [weak self] uploadResult in
            guard let `self` = self else { return }
            uploadResult.on(success: { imageContainer in
                let imageMessage = ImageMessage(description: message, brandId: collab.chatRoom.brandId, mediaUrl: imageContainer.url)
                self.imagePostService.post(using: imageMessage, completion: { imagePostResult in
                    imagePostResult.on(success: { _ in
                        let message = Message(text: message, mediaURL: imageContainer.url)
                        self.chatPostService.post(using: PostMessage(roomId: collab.chatRoomId, message: message), completion: { result in
                            result.on(success: { _ in completion(.success()) }, failure: { _ in completion(.failure(.chatPost)) })
                        })
                    }, failure: { _ in completion(.failure(.imagePost)) })
                })
            }, failure: { _ in completion(.failure(.imageUpload)) })
        }
    }
}
