//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class CategoriesResourceMock: Fetching {

    typealias Model = [Category]

    let categories: [Category] = [Category(id: "0", name: VyrlFaker.faker.commerce.department()),
                                  Category(id: "1", name: VyrlFaker.faker.commerce.department()),
                                  Category(id: "2", name: VyrlFaker.faker.commerce.department())]

    var success = true

    func fetch(completion: @escaping (Result<[Category], APIResponseError>) -> Void) {
        if success {
            completion(.success(categories))
        } else {
            completion(.failure(.unexpectedFailure(NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil))))
        }
    }
}
