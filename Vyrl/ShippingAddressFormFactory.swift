//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ShippingAddressFormMaking {
    static func make(fields: [FormView], actionDelegate: FormActionDelegate) -> ShippingAddressFormInteractor

}

enum ShippingAddressFormFactory: ShippingAddressFormMaking {

    static func make(fields: [FormView], actionDelegate: FormActionDelegate) -> ShippingAddressFormInteractor {
        guard fields.count == ShippingAddressFormIndex.count else {
            fatalError("Invalid form definition for ShippingAddressFormInteractor")
        }
        let streetItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.street])
        let apartmentItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.apartmentNumber])
        let cityItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.city])
        let stateItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.state])
        let zipCodeItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.zipCode])
        let countryItem = FormItem(field: .nonEmpty, formView: fields[ShippingAddressFormIndex.country])
        let formFieldsInteractor = FormFieldsInteractor(fields: [streetItem,
                                                                 apartmentItem,
                                                                 cityItem,
                                                                 stateItem,
                                                                 zipCodeItem,
                                                                 countryItem])
        formFieldsInteractor.delegate = actionDelegate
        return ShippingAddressFormInteractor(fieldsInteractor: formFieldsInteractor)
    }
}
