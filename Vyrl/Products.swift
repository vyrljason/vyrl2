//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Products {
    let products: [Product]
}

extension Products: Decodable {
    static func decode(_ json: Any) throws -> Products {
        return try self.init(products: [Product].decode(json))
    }
}
