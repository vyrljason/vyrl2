//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct PostImageEndpoint: APIEndpoint {
    let path: String = "/posts"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = JSONEncoding()

    init(message: ImageMessage) {
        parameters = message.dictionaryRepresentation
    }
}
