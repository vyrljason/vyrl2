//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class UserProfileServiceTests: XCTestCase {
    
    var resourceController: APIResourceControllerMock<UserProfile>!
    var resource: UserProfileResource!
    var service: Service<UserProfileResource>!
    var subject: UserProfileService!
    
    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<UserProfile>()
        resourceController.result = VyrlFaker.faker.userProfile()
        resource = UserProfileResource(controller: resourceController)
        service = Service<UserProfileResource>(resource: resource)
        subject = UserProfileService(resource: service)
    }
    
    func test_get_whenSuccess_returnsCollection() {
        resourceController.success = true
        
        subject.get { result in
            expectToBeSuccess(result)
        }
    }
    
    func test_get_whenFailure_returnsError() {
        resourceController.success = false
        
        subject.get { result in
            expectToBeFailure(result)
        }
    }
}
