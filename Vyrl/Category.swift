//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Category {

    fileprivate struct JSONKeys {
        static let name = "displayName"
        static let code = "code"
    }

    let id: String
    let name: String
}

extension Category: Decodable {
    static func decode(_ json: Any) throws -> Category {
        return try self.init(id: json => KeyPath(JSONKeys.code),
                             name: json => KeyPath(JSONKeys.name))
    }
}
