//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class UpdateUserSettingsServiceTest: XCTestCase {
    
    private var resourceController: APIResourceControllerMock<EmptyResponse>!
    private var subject: UpdateUserSettingsService!
    private var resource: UpdateUserSettingsResource!
    
    override func setUp() {
        super.setUp()
        resourceController = APIResourceControllerMock<EmptyResponse>()
        resourceController.result = EmptyResponse()
        resource = UpdateUserSettingsResource(controller: resourceController)
        let service = PostService<UpdateUserSettingsResource>(resource: resource)
        
        subject = UpdateUserSettingsService(resource: service)
    }
    
    func test_updateUserSettings_whenSuccess() {
        resourceController.success = true
        let userSettings = VyrlFaker.faker.userSettings()
        
        var wasCalled = false
        subject.update(userSettings: userSettings) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }
    
    func test_updateUserSettings_whenFailure() {
        resourceController.success = false
        let userSettings = VyrlFaker.faker.userSettings()
        
        var wasCalled = false
        subject.update(userSettings: userSettings) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
