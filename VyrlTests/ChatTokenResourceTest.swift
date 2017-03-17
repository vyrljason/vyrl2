//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class ChatTokenResourceTest: BaseAPIResourceTest {

    private var subject: ChatTokenResource!

    override func setUp() {
        super.setUp()
        subject = ChatTokenResource(controller: controller)
    }

    func test_fetch_callProperEndpoint() {
        let endpoint = ChatTokenEndpoint()

        subject.fetch { _ in }

        assertDidCallTo(endpoint)
    }
}
