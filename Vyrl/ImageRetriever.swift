//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Kingfisher

enum ImageRetrievingError: Error {
    case unknown
    case networkingError(NSError)
}

protocol ImageRetrieving: class {
    @discardableResult
    func retrieveImage(with url: URL, callback: @escaping ImageRetrieverCallback) -> ImageRetrievingTask
}

protocol Cancelable {
    func cancel()
}

protocol ImageRetrievingTask: Cancelable { }

typealias ImageRetrieverCallback = ((Result<UIImage, ImageRetrievingError>) -> Void)

extension RetrieveImageTask: ImageRetrievingTask { }

final class ImageRetrieverAdapter: ImageRetrieving {

    private let imageRetriever: KingfisherManager

    init(imageRetriever: KingfisherManager) {
        self.imageRetriever = imageRetriever
    }

    @discardableResult
    func retrieveImage(with url: URL, callback: @escaping ImageRetrieverCallback) -> ImageRetrievingTask {
        return imageRetriever.retrieveImage(with: url, options: nil, progressBlock: nil) {
            (image, error, cache, url) in
            if let image = image {
                callback(.success(image))
                return
            }
            if let error = error {
                callback(.failure(.networkingError(error)))
                return
            }
            callback(.failure(.unknown))
        }
    }
}
