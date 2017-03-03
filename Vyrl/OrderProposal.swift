//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct OrderProposal {
    fileprivate struct JSONKeys {
        static let products = "products"
        static let shippingAddress = "shippingAddress"
    }
    let shippingAddress: ShippingAddress
    let products: [CartItem]
}

extension OrderProposal: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        let productsAsDictionaries = products.map { $0.dictionaryRepresentation }
        return [JSONKeys.products: productsAsDictionaries,
                JSONKeys.shippingAddress: shippingAddress.dictionaryRepresentation]
    }
}
