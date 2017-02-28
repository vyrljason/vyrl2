//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Product {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let name = "name"
        static let retailPrice = "retailValue"
    }
    
    let id: String
    let name: String
    let retailPrice: Double
    let imageUrls: [String] = [] //not mapped
}

extension Product: Decodable {
    static func decode(_ json: Any) throws -> Product {
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             name: json => KeyPath(JSONKeys.name),
                             retailPrice: json => KeyPath(JSONKeys.retailPrice))
    }
}
