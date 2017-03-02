//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class BrandsResourceTest: BaseAPIResourceTest {

    private var subject: BrandsResource!
    private var request: BrandsRequest?

    override func setUp() {
        super.setUp()
        subject = BrandsResource(controller: controller)
    }

    func test_login_callProperEndpoint() {
        let endpoint = BrandsEndpoint(request: request)

        subject.fetchFiltered(using: request) { _ in }

        assertDidCallTo(endpoint)
    }
}
