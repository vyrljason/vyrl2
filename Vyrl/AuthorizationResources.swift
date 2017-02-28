//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UserAuthorizationInterface: APIResource {
    func signIn(using credentials: UserCredentials, completion: @escaping (Result<UserProfile, APIResponseError>) -> Void)
    func registerUser(using request: UserRegistrationRequest, completion: @escaping (Result<UserProfile, APIResponseError>) -> Void)
}

final class UserAuthorizationResources: UserAuthorizationInterface {

    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func signIn(using credentials: UserCredentials, completion: @escaping (Result<UserProfile, APIResponseError>) -> Void) {
        let endpoint = LoginEndpoint(userCredentials: credentials)
        controller.call(endpoint: endpoint, completion: completion)
    }

    func registerUser(using request: UserRegistrationRequest, completion: @escaping (Result<UserProfile, APIResponseError>) -> Void) {
        let endpoint = RegisterEndpoint(request: request)
        controller.call(endpoint: endpoint, completion: completion)
    }
}
