//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Industry {
    fileprivate enum JSONKeys {
        static let id = "id"
        static let name = "name"
    }
    let id: Int
    let name: String
}

extension Industry: Decodable {
    static func decode(_ json: Any) throws -> Industry {
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             name: json => KeyPath(JSONKeys.name))
    }
}
