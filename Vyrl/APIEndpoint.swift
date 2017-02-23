//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import Alamofire

enum AuthorizationType {
    private enum Constants {
        static let userHeaderPrefix = "Bearer"
    }
    case none
    case user

    func requestHeader(with token: String?) -> [String: String] {
        switch self {
        case .none: return [:]
        case .user:
            guard let token = token else { return [:] }
            return [String(describing: HTTPHeaderField.Authorization): Constants.userHeaderPrefix + " " + token]
        }
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
