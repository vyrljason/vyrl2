//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class LoginResourceMock: AuthorizingWithCredentials {

    var didCalledResource = false
    var success = true
    var credentials: UserCredentials?
    var result = VyrlFaker.faker.userToken()
    var error: APIResponseError = .connectionProblem

    func login(using credentials: UserCredentials, completion: @escaping (Result<UserToken, APIResponseError>) -> Void) {
        self.credentials = credentials
        didCalledResource = true
        if success {
            completion(.success(result))
        } else {
            completion(.failure(error))
        }
    }
}

final class LoginServiceTest: XCTestCase {

    var subject: LoginService!
    var resource: LoginResourceMock!
    var credentials: UserCredentials!

    override func setUp() {
        super.setUp()
        credentials = UserCredentials(username: "username", password: "password")
        resource = LoginResourceMock()
        subject = LoginService(resource: resource)
    }

    func test_login_whenResourceReturnsFailure_returnsFailure() {
        resource.success = false

        subject.login(using: credentials) { (result) in
            expectToBeFailure(result)
        }
    }

    func test_login_whenResourceReturnsSuccess_returnsSuccess() {
        resource.success = true

        subject.login(using: credentials) { (result) in
            expectToBeSuccess(result)
        }
    }
}
