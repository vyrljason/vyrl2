//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Collabs {
    let collabs: [Collab]
}

extension Collabs: Decodable {
    static func decode(_ json: Any) throws -> Collabs {
        return try self.init(collabs: [Collab].decode(json))
    }
}
