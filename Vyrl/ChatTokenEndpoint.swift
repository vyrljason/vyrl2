//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct ChatTokenEndpoint: APIEndpoint {
    let path = "/chats/token"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .get
    let parameters: [String: Any]? = nil
    let api: APIType = .main
    let encoding: ParameterEncoding = URLEncoding()
}
