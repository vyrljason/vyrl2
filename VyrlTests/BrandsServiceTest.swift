//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandsServiceTests: XCTestCase {

    var resourceController: APIResourceControllerMock<Brands>!
    var resource: BrandsResource!
    var service: ParameterizedService<BrandsResource>!
    var subject: BrandsService!

    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<Brands>()
        resourceController.result = Brands(brands: [])
        resource = BrandsResource(controller: resourceController)
        service = ParameterizedService<BrandsResource>(resource: resource)
        subject = BrandsService(resource: service)
    }

    func test_getFilteredBrands_withNoCategory_whenSuccess_returnsBrands() {
        resourceController.success = true

        var wasCalled = false
        subject.getFilteredBrands { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getFilteredBrands_withCategory_whenSuccess_returnsBrands() {
        resourceController.success = true
        let category = VyrlFaker.faker.category()
        var wasCalled = false
        subject.getFilteredBrands(for: category) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getFilteredBrands_whenFailure_returnsError() {
        resourceController.success = false

        var wasCalled = false
        subject.getFilteredBrands { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getBrands_whenSuccess_returnsBrands() {
        resourceController.success = true
        let ids = ["id1", "id2"]

        var wasCalled = false
        subject.getBrands(with: ids) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getBrands_whenFailure_returnsError() {
        resourceController.success = false
        let ids = ["id1", "id2"]

        var wasCalled = false
        subject.getBrands(with: ids) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
