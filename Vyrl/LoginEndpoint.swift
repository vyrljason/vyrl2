//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct LoginEndpoint: APIEndpoint {
    let path = "/auth/login"
    let authorization: AuthorizationType = .none
    let method: HTTPMethod = .get
    let modelClass: Decodable.Type? = AuthorizationCredentials.self
    let parameters: [String: Any]?

    init(userCredentials: UserCredentials) {
        parameters = userCredentials.dictionaryRepresentation
    }
}
