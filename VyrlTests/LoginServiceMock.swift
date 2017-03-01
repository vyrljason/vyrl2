//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import Foundation

final class LoginServiceMock: UserLoginProviding {
    var didCalledService = false
    var success = true
    var credentials: UserCredentials?
    var result = VyrlFaker.faker.userProfile()
    var error: LoginError = .unknown

    func login(using credentials: UserCredentials, completion: @escaping (Result<UserProfile, LoginError>) -> Void) {
        self.credentials = credentials
        didCalledService = true
        if success {
            completion(.success(result))
        } else {
            completion(.failure(error))
        }
    }
}
