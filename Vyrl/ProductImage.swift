//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct ProductImage {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let url = "imageUrl"
        static let name = "imageName"
        static let brandId = "brandId"
    }

    let id: String
    let url: URL
    let name: String
    let brandId: String
}

extension ProductImage: Decodable {
    static func decode(_ json: Any) throws -> ProductImage {
        guard let imageURL = try URL(string: json => KeyPath(JSONKeys.url)) else {
            throw DecodingError.typeMismatch(expected: URL.self, actual: String.self, DecodingError.Metadata(object: JSONKeys.url))
        }
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             url: imageURL,
                             name: json => KeyPath(JSONKeys.name),
                             brandId: json => KeyPath(JSONKeys.brandId))
    }
}
