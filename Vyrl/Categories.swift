//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Categories {
    let categories: [Category]
}

extension Categories: Decodable {
    static func decode(_ json: Any) throws -> Categories {
        return try self.init(categories: [Category].decode(json))
    }
}
