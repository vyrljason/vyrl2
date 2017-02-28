//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class UserAuthorizationResourcesTest: BaseAPIResourceTest {

    private var subject: UserAuthorizationResources!

    override func setUp() {
        super.setUp()
        subject = UserAuthorizationResources(controller: controller)
    }

    func test_login_callProperEndpoint() {
        let userCredentials = UserCredentials(username: "username", password: "password")
        let endpoint = LoginEndpoint(userCredentials: userCredentials)

        subject.signIn(using: userCredentials) { _ in }

        assertDidCallTo(endpoint)
    }

    func test_register_callProperEndpoint() {
        let request = UserRegistrationRequest(username: "username", email: "email", password: "password", platform: "instagram", platformUsername: "instagramusername")
        let endpoint = RegisterEndpoint(request: request)

        subject.registerUser(using: request) { _ in }

        assertDidCallTo(endpoint)
    }
}
