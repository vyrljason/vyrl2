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

        var wasCalled = false
        subject.get { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_get_whenFailure_returnsError() {
        resource.success = false

        var wasCalled = false
        subject.get { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
