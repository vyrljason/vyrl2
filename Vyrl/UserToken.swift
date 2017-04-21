//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct UserToken {
    fileprivate enum JSONKeys {
        static let token = "token"
    }
    let token: String
}

extension UserToken: Decodable {
    static func decode(_ json: Any) throws -> UserToken {
        return try self.init(token: json => KeyPath(JSONKeys.token))
    }
}
