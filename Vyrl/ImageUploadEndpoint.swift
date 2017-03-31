//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct ImageUploadEndpoint: APIEndpoint {
    let path = "/images/upload"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = URLEncoding()

    init(imageData: Data) {
        parameters = ["imageContent": imageData.base64EncodedString()]
    }
}
