//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let clientPlatformValue = "iOS"
    static let clientPlatformPrefix = "v"
    static let defaultAccept = "application/json"
    static let accessToken = "access_token"
}

enum HTTPHeaderField: String, CustomStringConvertible {
    case authorization = "Authorization"
    case platform = "client-platform"
    case version = "client-version"
    case accept = "Accept"

    var description: String {
        return self.rawValue
    }

    var value: String? {
        switch self {
        case .platform: return Constants.clientPlatformValue
        case .version: return Constants.clientPlatformPrefix + Bundle.main.applicationVersion
        case .accept: return Constants.defaultAccept
        default: return nil
        }
    }

    var header: [String: String] {
        guard let value = self.value else { return [:] }
        return [description: value]
    }
}

protocol RequestDataProviding {
    func headers(for endpoint: APIEndpoint) -> [String: String]
    func parameters(for endpoint: APIEndpoint) -> [String: Any]?
}

final class RequestDataProvider: RequestDataProviding {

    private let credentialsProvider: APICredentialsProviding

    init(credentialsProvider: APICredentialsProviding) {
        self.credentialsProvider = credentialsProvider
    }

    func headers(for endpoint: APIEndpoint) -> [String: String] {
        var headers: [String: String] = [:]
        switch endpoint.api {
        case .signedRequest:
            headers = endpoint.customHeaders
        default:
            headers = additionalHeaders
            headers += endpoint.authorization.requestHeader(with: credentialsProvider.userAccessToken, for: endpoint.api)
        }
        return headers
    }

    private var additionalHeaders: [String: String] {
        var headers: [String: String] = [:]
        headers += HTTPHeaderField.platform.header
        headers += HTTPHeaderField.version.header
        headers += HTTPHeaderField.accept.header
        return headers
    }

    func parameters(for endpoint: APIEndpoint) -> [String: Any]? {
        return  endpoint.parameters
    }
}
