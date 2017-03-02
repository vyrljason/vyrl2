//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandsServiceTests: XCTestCase {

    var resourceController: APIResourceControllerMock<Brands>!
    var resource: BrandsResource!
    var service: Service<BrandsResource>!
    var subject: BrandsService!

    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<Brands>()
        resourceController.result = Brands(brands: [])
        resource = BrandsResource(controller: resourceController)
        service = Service<BrandsResource>(resource: resource)
        subject = BrandsService(resource: service)
    }

    func test_get_whenSuccess_returnsBrands() {
        resourceController.success = true

        var wasCalled = false
        subject.get { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_get_whenFailure_returnsError() {
        resourceController.success = false

        var wasCalled = false
        subject.get { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
