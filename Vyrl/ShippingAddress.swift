//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

struct ShippingAddress {
    fileprivate struct JSONKeys {
        static let street = "street"
        static let apartment = "apartment"
        static let city = "city"
        static let state = "state"
        static let zipCode = "zip"
        static let country = "country"
    }
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
