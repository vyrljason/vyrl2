//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Orders {
    let orders: [Order]
}

extension Orders: Decodable {
    static func decode(_ json: Any) throws -> Orders {
        return try self.init(orders: [Order].decode(json))
    }
}
