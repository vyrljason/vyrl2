//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ImageUploading {
    func upload(image: UIImage, completion: @escaping (Result<ImageContainer, ServiceError>) -> Void)
}

final class ImageUploadService: ImageUploading {
    private let resource: ImageDataUploading
    private let imageConverter: ImageToDataConverting

    init(resource: ImageDataUploading, imageConverter: ImageToDataConverting) {
        self.resource = resource
        self.imageConverter = imageConverter
    }

    func upload(image: UIImage, completion: @escaping (Result<ImageContainer, ServiceError>) -> Void) {
        guard let data = imageConverter.convert(image: image) else {
            completion(.failure(.unknown))
            return
        }
        resource.upload(imageData: data) { result in
            completion(result.map(success: { .success($0) },
                                  failure: { .failure(.apiResponseError($0)) }))
        }
    }
}
