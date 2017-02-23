//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol UserAuthorizationInterface: APIResource {
    func login(using credentials: UserCredentials, completion: @escaping (Result<Brand, APIResponseError>) -> Void)
}

final class UserAuthorizationResources: UserAuthorizationInterface {

    private let httpClient: APIResourceControlling

    init(configurator: APIResourceConfiguring) {
        self.httpClient = configurator.httpClient
    }

    func login(using credentials: UserCredentials, completion: @escaping (Result<Brand, APIResponseError>) -> Void) {
        let endpoint = LoginEndpoint(userCredentials: credentials)
        httpClient.call(endpoint: endpoint, completion: completion)
    }
}
