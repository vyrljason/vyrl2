//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ImageDataUploading {
    func upload(imageData: Data, completion: @escaping (Result<ImageContainer, APIResponseError>) -> Void)
}

final class ImageUploadResource: ImageDataUploading, APIResource {

    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func upload(imageData: Data, completion: @escaping (Result<ImageContainer, APIResponseError>) -> Void) {
        controller.call(endpoint: ImageUploadEndpoint(imageData: imageData), completion: completion)
    }
}
