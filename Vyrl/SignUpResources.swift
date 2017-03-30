//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SigningUpWithCredentials: APIResource {
    func signUp(using request: UserSignUpRequest, completion: @escaping (Result<UserProfile, APIResponseError>) -> Void)
}

final class SignUpResources: SigningUpWithCredentials {

    private let controller: APIResourceControlling

    init(controller: APIResourceControlling) {
        self.controller = controller
    }

    func signUp(using request: UserSignUpRequest, completion: @escaping (Result<UserProfile, APIResponseError>) -> Void) {
        let endpoint = SignUpEndpoint(request: request)
        controller.call(endpoint: endpoint, completion: completion)
    }
}
