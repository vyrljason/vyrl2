//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum ImageMessageError: Error {
    case imageConversion
    case imageUpload
    case postUpload
}

protocol ImageMessageSending {
    func send(message: String, withImage image: UIImage, toRoom roomId: String, completion: @escaping (Result<Void, ImageMessageError>) -> Void)
}

final class ImageMessageService: ImageMessageSending {
    private let imageUploader: ImageDataUploading
    private let imageConverter: ImageToDataConverting
    private let postService: PostService<PostMessageResource>

    init(postService: PostService<PostMessageResource>,
         imageUploader: ImageDataUploading,
         imageConverter: ImageToDataConverting) {
        self.imageUploader = imageUploader
        self.imageConverter = imageConverter
        self.postService = postService
    }

    func send(message: String, withImage image: UIImage, toRoom roomId: String, completion: @escaping (Result<Void, ImageMessageError>) -> Void) {
        guard let data = imageConverter.convert(image: image) else {
            completion(.failure(.imageConversion))
            return
        }
        imageUploader.upload(imageData: data) { [weak self] uploadResult in
            guard let `self` = self else { return }
            uploadResult.on(success: { imageContainer in
                let message = Message(text: message, mediaURL: imageContainer.url)
                self.postService.post(using: PostMessage(roomId: roomId, message: message), completion: { result in
                    result.on(success: { _ in completion(.success()) }, failure: { _ in completion(.failure(.postUpload)) })
                })
            }, failure: { _ in completion(.failure(.imageUpload)) })
        }
    }
}
