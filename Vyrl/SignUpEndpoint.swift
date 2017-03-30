//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct SignUpEndpoint: APIEndpoint {
    let path = "/auth/local/register"
    let authorization: AuthorizationType = .none
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .influencers
    let encoding: ParameterEncoding = JSONEncoding()

    init(request: UserSignUpRequest) {
        parameters = request.dictionaryRepresentation
    }
}
