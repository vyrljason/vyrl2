//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ShippingAddressFormMaking {
    // swiftlint:disable function_parameter_count
    static func make(fields: [FormView]) -> ShippingAddressFormInteractor

}

enum ShippingAddressFormFactory: ShippingAddressFormMaking {

    // swiftlint:disable function_parameter_count
    static func make(fields: [FormView]) -> ShippingAddressFormInteractor {
        guard fields.count == ShippingAddressFormIndex.count else {
            fatalError("Invalid form definition for ShippingAddressFormInteractor")
        }
        let streetItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.street.integerValue])
        let apartmentItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.apartmentNumber.integerValue])
        let cityItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.city.integerValue])
        let stateItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.state.integerValue])
        let zipCodeItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.zipCode.integerValue])
        let countryItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.country.integerValue])
        return ShippingAddressFormInteractor(fields: [streetItem,
                                                      apartmentItem,
                                                      cityItem,
                                                      stateItem,
                                                      zipCodeItem,
                                                      countryItem])
    }
}
