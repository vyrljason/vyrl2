//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class BrandsResourceTest: BaseAPIResourceTest {

    private var subject: BrandsResource!

    override func setUp() {
        super.setUp()
        subject = BrandsResource(controller: controller)
    }

    func test_login_callProperEndpoint() {
        let endpoint = BrandsEndpoint()

        subject.fetch { _ in }

        assertDidCallTo(endpoint)
    }
}
