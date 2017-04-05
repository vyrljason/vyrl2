//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct InfluencerPostsEndpoint: APIEndpoint {
    let path: String = "/posts"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .get
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = URLEncoding()

    init(request: InfluencerPostsRequest) {
        parameters = request.dictionaryRepresentation
    }
}
