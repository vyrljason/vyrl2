//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum HTTPHeaderField: String, CustomStringConvertible {
    case Authorization
    case Platform = "client-platform"
    case Version = "client-version"

    var description: String {
        return self.rawValue
    }
}

private enum Constants {
    static let clientPlatformValue = "iOS"
    static let clientPlatformPrefix = "v"
}

protocol HTTPHeadersProviding {
    func headersFor(endpoint: APIEndpoint) -> [String: String]
}

final class HTTPHeadersProvider: HTTPHeadersProviding {

    private let credentialsProvider: APICredentialsProviding

    init(credentialsProvider: APICredentialsProviding) {
        self.credentialsProvider = credentialsProvider
    }

    func headersFor(endpoint: APIEndpoint) -> [String : String] {
        var headers: [String: String] = additionalHeaders
        headers += headerFor(authorizationType: endpoint.authorization)
        return headers
    }

    private func headerFor(authorizationType: AuthorizationType) -> [String: String] {
        return authorizationType.requestHeader(with: credentialsProvider.userAccessToken)
    }

    private var additionalHeaders: [String: String] {
        return [
            HTTPHeaderField.Platform.description: Constants.clientPlatformValue,
            HTTPHeaderField.Version.description: Constants.clientPlatformPrefix +  Bundle.main.applicationVersion
        ]
    }
}
