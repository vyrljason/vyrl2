//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Alamofire

enum AuthorizationType {
    private enum Constants {
        static let userHeaderPrefix = "Bearer"
    }
    case none
    case user

    func requestHeader(with token: String?, for api: APIType) -> [String: String] {
        switch self {
        case .none: return [:]
        case .user:
            guard let token = token else { return [:] }
            switch api {
            case .influencers:
                return [String(describing: HTTPHeaderField.authorization): Constants.userHeaderPrefix + " " + token]
            case .main:
                return [String(describing: HTTPHeaderField.authorization): token]
            default:
                return [:]
            }
        }
    }
}

protocol APIEndpoint {
    var path: String { get }
    var authorization: AuthorizationType { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var api: APIType { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var customHeaders: [String: String] { get }
}

extension APIEndpoint {
    var customHeaders: [String: String] {
        return [:]
    }
}

enum APIType {
    case main
    case influencers
    case signedRequest
}

extension APIType {
    func baseURL(using configuration: APIConfigurationHaving) -> URL {
        switch self {
        case .main: return configuration.mainBaseURL
        case .influencers: return configuration.influencersBaseURL
        case .signedRequest: return URL(string: "")!
        }
    }
}
