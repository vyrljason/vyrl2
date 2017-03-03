//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct ProductVariants {
    fileprivate struct JSONKeys {
        static let name = "name"
        static let values = "values"
    }

    let name: String
    let values: [String]
}

extension ProductVariants: Decodable {
    static func decode(_ json: Any) throws -> ProductVariants {

        return try self.init(name: json => KeyPath(JSONKeys.name),
                             values: json => KeyPath(JSONKeys.values))
    }
}

struct ProductVariant {
    fileprivate struct JSONKeys {
        static let name = "name"
        static let value = "value"
    }
    let name: String
    let value: String
}

extension ProductVariant: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.name: name,
                JSONKeys.value: value]
    }
}
