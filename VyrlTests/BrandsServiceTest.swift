//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandsServiceTests: XCTestCase {

    var resource: BrandsResourceMock!
    var service: Service<BrandsResourceMock>!
    var subject: BrandsService!

    override func setUp() {
        super.setUp()
        resource = BrandsResourceMock(amount: 1)
        service = Service<BrandsResourceMock>(resource: resource)
        subject = BrandsService(resource: service)
    }

    func test_get_whenSuccess_returnsBrands() {
        resource.success = true

        subject.get { result in
            expectToBeSuccess(result)
        }
    }

    func test_get_whenFailure_returnsError() {
        resource.success = false

        subject.get { result in
            expectToBeFailure(result)
        }
    }
}
