//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CollabsServiceTest: XCTestCase {

    private var subject: CollabsService!
    private var resource: CollabsResourceMock!

    override func setUp() {
        super.setUp()
        resource = CollabsResourceMock(amount: 10)
        let service = Service<CollabsResourceMock>(resource: resource)
        subject = CollabsService(resource: service)
    }

    func test_getProducts_whenSuccess_returnsBrands() {
        resource.success = true

        var wasCalled = false
        subject.getCollabs { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getProducts_whenFailure_returnsError() {
        resource.success = false

        var wasCalled = false
        subject.getCollabs { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
