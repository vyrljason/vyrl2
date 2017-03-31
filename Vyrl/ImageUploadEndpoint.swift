//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct ImageUploadEndpoint: APIEndpoint {
    let path = "/images"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .post
    let parameters: [String: Any]? = nil
    let api: APIType = .main
    let encoding: ParameterEncoding = JSONEncoding()
}
