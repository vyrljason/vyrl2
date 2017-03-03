//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ProductsServiceTest: XCTestCase {

    private var resourceController: APIResourceControllerMock<Products>!
    private var subject: ProductsService!
    private var resource: ProductsResource!
    private var productIds: [String]!

    override func setUp() {
        super.setUp()
        productIds = [VyrlFaker.faker.lorem.characters(amount: 20), VyrlFaker.faker.lorem.characters(amount: 20)]
        resourceController = APIResourceControllerMock<Products>()
        resourceController.result = Products(products: [])
        resource = ProductsResource(controller: resourceController)
        let service = ParameterizedService<ProductsResource>(resource: resource)
        subject = ProductsService(resource: service)
    }

    func test_getProducts_whenSuccess_returnsBrands() {
        resourceController.success = true

        var wasCalled = false
        subject.getProducts(with: productIds) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getProducts_whenFailure_returnsError() {
        resourceController.success = false

        var wasCalled = false
        subject.getProducts(with: productIds) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
