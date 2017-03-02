//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class CategoriesResourceTest: BaseAPIResourceTest {

    private var subject: CategoriesResource!

    override func setUp() {
        super.setUp()
        subject = CategoriesResource(controller: controller)
    }

    func test_login_callProperEndpoint() {
        let endpoint = CategoriesEndpoint()

        subject.fetch { _ in }

        assertDidCallTo(endpoint)
    }
}
