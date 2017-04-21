//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class IndustriesResourceTest: BaseAPIResourceTest {
    
    private var subject: IndustriesResource!
    
    override func setUp() {
        super.setUp()
        subject = IndustriesResource(controller: controller)
    }
    
    func test_fetch_callProperEndpoint() {
        let endpoint = IndustriesEndpoint()
        
        subject.fetch { _ in }
        
        assertDidCallTo(endpoint)
    }
}
