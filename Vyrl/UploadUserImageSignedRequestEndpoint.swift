//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct UploadUserImageSignedRequestEndpoint: APIEndpoint {
    let path: String = ""
    let authorization: AuthorizationType = .none
    let method: HTTPMethod = .put
    let parameters: [String: Any]? = nil
    let api: APIType
    let encoding: ParameterEncoding = JSONEncoding()
    let customHeaders: [String : String] = ["Connection": "close",
                                            "Content-Type": "image/png"]
    
    init(signedRequest: URL) {
        self.api = .signedRequest(url: signedRequest)
    }
}
