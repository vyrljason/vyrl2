//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandsResourceTestMock: BrandsFetching {

    let brands: [Brand] = (0..<5).map { _ in VyrlFaker.faker.brand() }
    let error: APIResponseError = .unexpectedFailure
    var success = true

    func brands(completion: @escaping BrandsAPIResultClosure) {
        if success {
            completion(.success(brands))
        } else {
            completion(.failure(error))
        }
    }
}

final class BrandsResourceMock: XCTestCase {

    var resource: BrandsResourceTestMock!
    var subject: BrandsService!

    override func setUp() {
        super.setUp()
        resource = BrandsResourceTestMock()
        subject = BrandsService(resource: resource)
    }

    func test_brands_whenSuccess_returnsBrands() {
        resource.success = true

        subject.brands { result in
            expectToBeSuccess(result)
        }
    }

    func test_brands_whenFailure_returnsError() {
        resource.success = false

        subject.brands { result in
            expectToBeFailure(result)
        }
    }
}
