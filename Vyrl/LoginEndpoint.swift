//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct LoginEndpoint: APIEndpoint {
    let path = "/auth/local"
    let authorization: AuthorizationType = .none
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = JSONEncoding()

    init(userCredentials: UserCredentials) {
        parameters = userCredentials.dictionaryRepresentation
    }
}
