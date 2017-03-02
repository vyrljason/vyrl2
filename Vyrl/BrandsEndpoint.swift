//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct BrandsEndpoint: APIEndpoint {
    let path = "/brands"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .get
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = URLEncoding()

    init(request: BrandsRequest?) {
        parameters = request?.dictionaryRepresentation
    }
}
