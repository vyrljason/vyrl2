//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct SocialNetworkProfile {
    fileprivate struct JSONKeys {
        static let username = "username"
    }
    let username: String
}

extension SocialNetworkProfile: Decodable {
    static func decode(_ json: Any) throws -> SocialNetworkProfile {
        return try self.init(username: json => KeyPath(JSONKeys.username))
    }
}
