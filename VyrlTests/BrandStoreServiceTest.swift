//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class BrandStoreServiceTest: XCTestCase {
    
    var subject: BrandStoreService!
    var resource: ProductsResourceMock!
    
    override func setUp() {
        super.setUp()
        resource = ProductsResourceMock(amount: 1)
        let service = Service<ProductsResourceMock>(resource: resource)
        subject = BrandStoreService(resource: service)
    }
    
    func test_get_whenSuccess_returnsProducts() {
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
