//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct Product {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let name = "name"
        static let description = "desc"
        static let brandId = "brandId"
        static let retailPrice = "retailValue"
        static let imageIds = "imageIds"
        static let category = "category"
        static let isAdditionalGuidelines = "additionalGuidelines"
        static let additionalGuidelines = "additionalGuidelinesContent"
        static let images = "images"
        static let variants = "_variants"
    }

    let id: String
    let name: String
    let description: String
    let category: String
    let brandId: String
    let retailPrice: Double
    let isAdditionalGuidelines: Bool
    let additionalGuidelines: String?
    let images: [ImageContainer]
    let variants: [ProductVariants]
}

extension Product: Decodable {
    static func decode(_ json: Any) throws -> Product {
        return try self.init(id: json => KeyPath(JSONKeys.id),
                             name: json => KeyPath(JSONKeys.name),
                             description: json => KeyPath(JSONKeys.description),
                             category: json => KeyPath(JSONKeys.category),
                             brandId: json => KeyPath(JSONKeys.brandId),
                             retailPrice: json => KeyPath(JSONKeys.retailPrice),
                             isAdditionalGuidelines: json =>? OptionalKeyPath(stringLiteral: JSONKeys.isAdditionalGuidelines) ?? false,
                             additionalGuidelines: json =>? OptionalKeyPath(stringLiteral: JSONKeys.additionalGuidelines),
                             images: json =>? OptionalKeyPath(stringLiteral: JSONKeys.images) ?? [],
                             variants: json =>? OptionalKeyPath(stringLiteral: JSONKeys.variants) ?? [])
    }
}
