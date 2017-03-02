//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Brands {
    let brands: [Brand]
}

extension Brands: Decodable {
    static func decode(_ json: Any) throws -> Brands {
        return try self.init(brands: [Brand].decode(json))
    }
}
