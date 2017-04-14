//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct DeleteUserEndpoint: APIEndpoint {
    let path: String = "/user/disable"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .put
    let parameters: [String: Any]? = nil
    let api: APIType = .influencers
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
}
