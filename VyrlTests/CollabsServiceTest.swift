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

    func test_getCollabs_whenSuccess_returnsCollabs() {
        resource.success = true

        var wasCalled = false
        subject.getCollabs { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getCollabs_whenFailure_returnsError() {
        resource.success = false

        var wasCalled = false
        subject.getCollabs { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
