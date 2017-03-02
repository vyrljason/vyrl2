//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct CategoriesEndpoint: APIEndpoint {
    let path = "/categories"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .get
    let parameters: [String: Any]? = nil
    let api: APIType = .main
    let encoding: ParameterEncoding = URLEncoding()

}
