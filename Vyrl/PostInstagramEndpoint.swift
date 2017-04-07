//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct PostInstagramEndpoint: APIEndpoint {
    let path: String = "/posts/posted"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .patch
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = JSONEncoding()

    init(post: InstagramPost) {
        parameters = post.dictionaryRepresentation
    }
}
