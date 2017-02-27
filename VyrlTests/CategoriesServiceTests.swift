//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CategoriesServiceTests: XCTestCase {

    var resource: CategoriesResourceMock!
    var service: Service<CategoriesResourceMock>!
    var subject: CategoriesService!

    override func setUp() {
        super.setUp()
        resource = CategoriesResourceMock()
        service = Service<CategoriesResourceMock>(resource: resource)
        subject = CategoriesService(resource: service)
    }

    func test_get_whenSuccess_returnsCollection() {
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
