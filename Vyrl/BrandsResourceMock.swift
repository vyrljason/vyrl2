//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Fakery

protocol BrandsFetching {
    func brands(completion: @escaping BrandsAPIResultClosure)
}

final class BrandsResourceMock: BrandsFetching {

    private let brands: [Brand]
    var success = true

    init(amount: Int) {
        brands = (0..<amount).map { _ in VyrlFaker.faker.brand() }
    }

    func brands(completion: @escaping BrandsAPIResultClosure) {
        if success {
            completion(.success(brands))
        } else {
            completion(.failure(.unexpectedFailure))
        }
    }
}
