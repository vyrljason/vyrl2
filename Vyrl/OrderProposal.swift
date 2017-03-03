//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable

struct OrderProposal {
    fileprivate struct JSONKeys {
        static let products = "products"
        static let shippingAddress = "shippingAddress"
        static let contactInfo = "contactInfo"
    }
    let shippingAddress: ShippingAddress
    let contactInfo: ContactInfo
    let products: [CartItem]

    init(products: [CartItem],
         shippingAddress: ShippingAddress = VyrlFaker.faker.shippingAddress(), //FIXME: Remove default value
         contactInfo: ContactInfo = VyrlFaker.faker.contactInfo()) { //FIXME: Remove default value
        self.products = products
        self.shippingAddress = shippingAddress
        self.contactInfo = contactInfo
    }
}

extension OrderProposal: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        let productsAsDictionaries = products.map { $0.dictionaryRepresentation }
        return [JSONKeys.products: productsAsDictionaries,
                JSONKeys.contactInfo: contactInfo.dictionaryRepresentation,
                JSONKeys.shippingAddress: shippingAddress.dictionaryRepresentation]
    }
}
