//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

private enum Constants {
    static let pathPrefix = "/posts/"
}

struct PostInstagramEndpoint: APIEndpoint {
    let path: String
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .patch
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = JSONEncoding()

    init(post: InstagramPost) {
        path = Constants.pathPrefix + post.postId
        parameters = post.dictionaryRepresentation
    }
}
