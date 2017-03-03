//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct ShippingAddress {
    fileprivate struct JSONKeys {
        static let id = "id"
        static let street = "street"
        static let apartment = "apartment"
        static let city = "city"
        static let state = "state"
        static let zipCode = "zip"
        static let country = "country"
    }
    let id: String?
    let street: String
    let apartment: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
}

extension ShippingAddress: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.street: street,
                JSONKeys.apartment: apartment,
                JSONKeys.city: city,
                JSONKeys.state: state,
                JSONKeys.zipCode: zipCode,
                JSONKeys.country: country
        ]
    }
}

extension ShippingAddress: Decodable {
    static func decode(_ json: Any) throws -> ShippingAddress {
        return try self.init(id: json =>? OptionalKeyPath(stringLiteral: JSONKeys.id),
                             street: json =>? OptionalKeyPath(stringLiteral: JSONKeys.street) ?? "",
                             apartment: json =>? OptionalKeyPath(stringLiteral: JSONKeys.apartment) ?? "",
                             city: json =>? OptionalKeyPath(stringLiteral: JSONKeys.city) ?? "",
                             state: json =>? OptionalKeyPath(stringLiteral: JSONKeys.state) ?? "",
                             zipCode: json =>? OptionalKeyPath(stringLiteral: JSONKeys.zipCode) ?? "",
                             country: json =>? OptionalKeyPath(stringLiteral: JSONKeys.country) ?? "")
    }
}
