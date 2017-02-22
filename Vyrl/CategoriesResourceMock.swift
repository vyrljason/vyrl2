//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class CategoriesResourceMock: Fetching {
    typealias Model = [Category]
    func fetch(completion: @escaping (Result<[Category], APIResponseError>) -> Void) {
        completion(.success([Category(id: "0", name: VyrlFaker.faker.commerce.department()),
                             Category(id: "1", name: VyrlFaker.faker.commerce.department()),
                             Category(id: "2", name: VyrlFaker.faker.commerce.department())]))
    }
}
