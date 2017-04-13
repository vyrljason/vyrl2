//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol AuthorizingWithCredentials {
    func login(using credentials: UserCredentials, completion: @escaping (Result<UserToken, APIResponseError>) -> Void)
}

final class UserLoginResource: AuthorizingWithCredentials {

    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func login(using credentials: UserCredentials, completion: @escaping (Result<UserToken, APIResponseError>) -> Void) {
        let endpoint = LoginEndpoint(userCredentials: credentials)
        controller.call(endpoint: endpoint, completion: completion)
    }
}
