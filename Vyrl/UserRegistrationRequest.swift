//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct UserRegistrationRequest {
    fileprivate enum JSONKeys {
        static let username = "username"
        static let email = "email"
        static let password = "password"
        static let platform = "platform"
        static let platformUsername = "platformUsername"
    }
    private enum Constants {
        static let defaultPlatform = "instagram"
    }

    let username: String
    let email: String
    let password: String
    let platform: String
    let platformUsername: String

    init(username: String, email: String, password: String, platform: String = Constants.defaultPlatform, platformUsername: String) {
        self.username = username
        self.email = email
        self.password = password
        self.platform = platform
        self.platformUsername = platformUsername
    }
}

extension UserRegistrationRequest : DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.username: username,
                JSONKeys.email: email,
                JSONKeys.password: password,
                JSONKeys.platform: platform,
                JSONKeys.platformUsername: platformUsername]
    }
}
