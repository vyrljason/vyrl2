//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class ImageRetrieverTaskMock: ImageRetrievingTask {
    var cancelDidCall = false

    func cancel() {
        cancelDidCall = true
    }
}

final class ImageRetrieverMock: ImageRetrieving {
    var success = true
    var didFinishCallback = true
    var image = UIImage()
    var error: NSError? = NSError()
    var urlCalled: URL?
    var lastTask: ImageRetrieverTaskMock?

    func retrieveImage(with url: URL, callback: @escaping ImageRetrieverCallback) -> ImageRetrievingTask {
        urlCalled = url
        lastTask = ImageRetrieverTaskMock()
        if didFinishCallback {
            if success {
                callback(.success(image))
                return lastTask!
            }
            if let error = error {
                callback(.failure(.networkingError(error)))
                return lastTask!
            }
            callback(.failure(.unknown))
        }
        return lastTask!
    }
}
