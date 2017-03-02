//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct RegisterEndpoint: APIEndpoint {
    let path = "/auth/local/register"
    let authorization: AuthorizationType = .none
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = JSONEncoding()

    init(request: UserRegistrationRequest) {
        parameters = request.dictionaryRepresentation
    }
}
