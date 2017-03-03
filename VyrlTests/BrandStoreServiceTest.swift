//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandStoreServiceTest: XCTestCase {

    private var resourceController: APIResourceControllerMock<Products>!
    private var subject: BrandStoreService!
    private var resource: ProductsResource!
    private var brand: Brand!

    override func setUp() {
        super.setUp()
        brand = VyrlFaker.faker.brand()
        resourceController = APIResourceControllerMock<Products>()
        resourceController.result = Products(products: [])
        resource = ProductsResource(controller: resourceController)
        let service = ParameterizedService<ProductsResource>(resource: resource)
        subject = BrandStoreService(resource: service)
    }
    
    func test_getProducts_whenSuccess_returnsBrands() {
        resourceController.success = true

        var wasCalled = false
        subject.getProducts(for: brand) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getProducts_whenFailure_returnsError() {
        resourceController.success = false

        var wasCalled = false
        subject.getProducts(for: brand) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
