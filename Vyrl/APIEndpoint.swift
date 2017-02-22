//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import Alamofire

enum AuthorizationType {
    case none
    case user
}

extension AuthorizationType {
    var headerKey: String {
        return "Authorization"
    }
}

protocol APIEndpoint {
    var path: String { get }
    var authorization: AuthorizationType { get }
    var method: HTTPMethod { get }
    var modelClass: Decodable.Type? { get }
    var parameters: [String: Any]? { get }
}

extension APIEndpoint {
    var encoding: Alamofire.ParameterEncoding {
        return JSONEncoding()
    }
}
