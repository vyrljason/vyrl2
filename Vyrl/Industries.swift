//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Industries {
    let industries: [Industry]
}

extension Industries: Decodable {
    static func decode(_ json: Any) throws -> Industries {
        return try self.init(industries: [Industry].decode(json))
    }
}
