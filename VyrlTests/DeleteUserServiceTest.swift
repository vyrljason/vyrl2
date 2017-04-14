//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class DeleteUserServiceTest: XCTestCase {
    
    private var resourceController: APIResourceControllerMock<EmptyResponse>!
    private var subject: DeleteUserService!
    private var resource: DeleteUserResource!
    
    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<EmptyResponse>()
        resourceController.result = EmptyResponse()
        resource = DeleteUserResource(controller: resourceController)
        let service = Service<DeleteUserResource>(resource: resource)
        
        subject = DeleteUserService(resource: service)
    }
    
    func test_deleteUser_whenSuccess() {
        resourceController.success = true
        
        var wasCalled = false
        subject.delete { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }
    
    func test_deleteUser_whenFailure() {
        resourceController.success = false
        
        var wasCalled = false
        subject.delete { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
