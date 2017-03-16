//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class CollabsResourceMock: Fetching {

    typealias Model = Collabs

    private let items: Collabs
    var success = true

    init(amount: Int) {
        items = Collabs(collabs: (0..<amount).map { _ in VyrlFaker.faker.collab() })
    }

    func fetch(completion: @escaping (Result<Collabs, APIResponseError>) -> Void) {
        if success {
            completion(.success(items))
        } else {
            completion(.failure(.unexpectedFailure(NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil))))
        }
    }
}
