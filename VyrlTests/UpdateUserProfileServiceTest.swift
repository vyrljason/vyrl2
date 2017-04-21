//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class UpdateUserProfileServiceTest: XCTestCase {
    
    private var resourceController: APIResourceControllerMock<EmptyResponse>!
    private var subject: UpdateUserProfileService!
    private var resource: UpdateUserProfileResource!
    
    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<EmptyResponse>()
        resourceController.result = EmptyResponse()
        resource = UpdateUserProfileResource(controller: resourceController)
        let service = PostService<UpdateUserProfileResource>(resource: resource)
        
        subject = UpdateUserProfileService(resource: service)
    }
    
    func test_updateUserProfile_whenSuccess() {
        resourceController.success = true
        let userProfile = VyrlFaker.faker.updatedUserProfile()
        
        var wasCalled = false
        subject.update(updatedUserProfile: userProfile) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }
    
    func test_updateUserProfile_whenFailure() {
        resourceController.success = false
        let userProfile = VyrlFaker.faker.updatedUserProfile()
        
        var wasCalled = false
        subject.update(updatedUserProfile: userProfile) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
