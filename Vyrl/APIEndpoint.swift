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
    var parameters: [String: Any]? { get }
    var api: APIType { get }
}

extension APIEndpoint {
    var encoding: Alamofire.ParameterEncoding {
        return JSONEncoding()
    }
}

enum APIType {
    case main
    case influencers
}

extension APIType {
    func baseURL(using configuration: APIConfigurationHaving) -> URL {
        switch self {
        case .main: return configuration.mainBaseURL
        case .influencers: return configuration.influencersBaseURL
        }
    }
}
