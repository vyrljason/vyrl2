//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Product {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let name = "name"
        static let description = "description"
        static let brandId = "brandId"
        static let retailPrice = "retailValue"
        static let imageIds = "imageIds"
    }
    
    let id: String
    let name: String
    let description: String
    let brandId: String
    let retailPrice: Double
    let imageUrls: [String]
}

extension Product: Decodable {
    static func decode(_ json: Any) throws -> Product {
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             name: json => KeyPath(JSONKeys.name),
                             description: json => KeyPath(JSONKeys.description),
                             brandId: json => KeyPath(JSONKeys.brandId),
                             retailPrice: json => KeyPath(JSONKeys.retailPrice),
                             imageUrls: json => KeyPath(JSONKeys.imageIds)
        )
    }
}
