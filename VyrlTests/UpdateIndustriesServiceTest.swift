//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class UpdateUserIndustriesServiceTest: XCTestCase {
    
    private var resourceController: APIResourceControllerMock<EmptyResponse>!
    private var subject: UpdateUserIndustriesService!
    private var resource: UpdateUserIndustriesResource!
    
    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<EmptyResponse>()
        resourceController.result = EmptyResponse()
        resource = UpdateUserIndustriesResource(controller: resourceController)
        let service = PostService<UpdateUserIndustriesResource>(resource: resource)
        
        subject = UpdateUserIndustriesService(resource: service)
    }
    
    func test_updateUserIndustries_whenSuccess() {
        resourceController.success = true
        let userIndustries = VyrlFaker.faker.updatedUserIndustries()
        
        var wasCalled = false
        subject.update(updatedUserIndustries: userIndustries) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }
    
    func test_updateUserIndustries_whenFailure() {
        resourceController.success = false
        let userIndustries = VyrlFaker.faker.updatedUserIndustries()
        
        var wasCalled = false
        subject.update(updatedUserIndustries: userIndustries) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
