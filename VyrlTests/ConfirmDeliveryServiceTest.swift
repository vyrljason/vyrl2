//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ConfirmDeliveryServiceTest: XCTestCase {

    private var resourceController: APIResourceControllerMock<EmptyResponse>!
    private var subject: ConfirmDeliveryService!
    private var resource: ConfirmDeliveryResource!

    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<EmptyResponse>()
        resourceController.result = EmptyResponse()
        resource = ConfirmDeliveryResource(controller: resourceController)
        let service = PostService<ConfirmDeliveryResource>(resource: resource)

        subject = ConfirmDeliveryService(resource: service)
    }

    func test_confirmDelivery_whenSuccess_returnsBrands() {
        resourceController.success = true
        let brandId = "brandId"

        var wasCalled = false
        subject.confirmDelivery(forBrand: brandId) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_confirmDelivery_whenFailure_returnsError() {
        resourceController.success = false
        let brandId = "brandId"

        var wasCalled = false
        subject.confirmDelivery(forBrand: brandId) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }

}
