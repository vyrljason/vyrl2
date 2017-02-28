//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct LoginEndpoint: APIEndpoint {
    let path = "/auth/local"
    let authorization: AuthorizationType = .none
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .influencers

    init(userCredentials: UserCredentials) {
        parameters = userCredentials.dictionaryRepresentation
    }
}
