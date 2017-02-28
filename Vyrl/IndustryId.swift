//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct IndustryId {
    fileprivate enum JSONKeys {
        static let id = "id"
    }
    let id: Int
}

extension IndustryId: Decodable {
    static func decode(_ json: Any) throws -> IndustryId {
        return try self.init(id: json => KeyPath(JSONKeys.id))
    }
}
