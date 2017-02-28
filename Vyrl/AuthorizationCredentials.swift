//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct AuthorizationCredentials {
    fileprivate enum JSONKeys {
        static let AccessToken = "access_token"
        static let ExpiresIn = "expires_in"
        static let TokenType = "token_type"
    }

    let accessToken: String
    let expiresIn: TimeInterval
    let tokenType: String
}

extension AuthorizationCredentials : Decodable {
    static func decode(_ json: Any) throws -> AuthorizationCredentials {
        return try self.init(accessToken: json => KeyPath(JSONKeys.AccessToken),
                             expiresIn: json => KeyPath(JSONKeys.ExpiresIn),
                             tokenType: json => KeyPath(JSONKeys.TokenType))
    }
}
