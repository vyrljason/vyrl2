//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

final class BrandsResourceMock: Fetching {

    typealias Model = [Brand]

    private let brands: [Brand]
    var success = true

    init(amount: Int) {
        brands = (0..<amount).map { _ in VyrlFaker.faker.brand() }
    }

    func fetch(completion: @escaping (Result<[Brand], APIResponseError>) -> Void) {
        if success {
            completion(.success(brands))
        } else {
            completion(.failure(.unexpectedFailure))
        }
    }
}
