//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class ImageFetcherMock: ImageFetching {
    var success = true
    var didCancel = false
    var image = UIImage()
    var error: NSError? = NSError()

    func fetchImage(callback: @escaping ImageRetrieverCallback) {
        if success {
            callback(.success(image))
            return
        }
        if let error = error {
            callback(.failure(.networkingError(error)))
            return
        }
        callback(.failure(.unknown))
    }

    func cancel() {
        didCancel = true
    }
}
