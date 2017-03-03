//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct ProductsEndpoint: APIEndpoint {
    let path = "/products"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .get
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = URLEncoding()

    init(request: ProductsRequest?) {
        parameters = request?.dictionaryRepresentation
    }
}
