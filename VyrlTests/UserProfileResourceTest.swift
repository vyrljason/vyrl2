//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class UserProfileResourceTest: BaseAPIResourceTest {
    
    private var subject: UserProfileResource!
    
    override func setUp() {
        super.setUp()
        subject = UserProfileResource(controller: controller)
    }
    
    func test_fetch_callProperEndpoint() {
        let endpoint = UserProfileEndpoint()
        
        subject.fetch { _ in }
        
        assertDidCallTo(endpoint)
    }
}
