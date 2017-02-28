//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct RegisterEndpoint: APIEndpoint {
    let path = "/auth/local/register"
    let authorization: AuthorizationType = .none
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .influencers

    init(request: UserRegistrationRequest) {
        parameters = request.dictionaryRepresentation
    }
}
