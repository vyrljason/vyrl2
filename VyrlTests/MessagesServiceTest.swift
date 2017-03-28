//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesServiceTest: XCTestCase {
    
    private var subject: MessagesService!
    private var resource: MessagesResourceMock!
    
    override func setUp() {
        super.setUp()
        resource = MessagesResourceMock(amount: 10)
        let service = Service<MessagesResourceMock>(resource: resource)
        subject = MessagesService(resource: service)
    }
    
    func test_getMessages_whenSuccess_returnsMessages() {
        resource.success = true
        
        var wasCalled = false
        subject.getMessages { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }
    
    func test_getMessages_whenFailure_returnsError() {
        resource.success = false
        
        var wasCalled = false
        subject.getMessages { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
