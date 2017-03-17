//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct ChatToken {
    fileprivate enum JSONKeys {
        static let token = "chatToken"
    }

    let token: String
}

extension ChatToken: Decodable {
    static func decode(_ json: Any) throws -> ChatToken {
        return try self.init(token: json => KeyPath(JSONKeys.token))
    }
}

extension ChatToken: CustomStringConvertible {
    var description: String {
        return token
    }
}
