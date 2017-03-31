//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

struct ConfirmDeliveryEndpoint: APIEndpoint {
    let path = "/order/active/delivered"
    let authorization: AuthorizationType = .user
    let method: HTTPMethod = .post
    let parameters: [String: Any]?
    let api: APIType = .main
    let encoding: ParameterEncoding = JSONEncoding()

    init(request: ConfirmDeliveryRequest) {
        parameters = request.dictionaryRepresentation
    }
}
