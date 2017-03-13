//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let invalidData = NSLocalizedString("shippingAddress.error.invalid", comment: "")
}

protocol ShippingFormInteracting: class, FormInteracting, UITextFieldDelegate {
    var result: ShippingAddress? { get }
}

enum ShippingAddressFormIndex: Int, CustomIntegerConvertible {
    case street
    case apartmentNumber
    case city
    case state
    case zipCode
    case country

    var integerValue: Int {
        return rawValue
    }

    static var count: Int {
        let lastElement = ShippingAddressFormIndex.country
        return lastElement.integerValue + 1
    }
}

final class ShippingAddressFormInteractor: NSObject, ShippingFormInteracting {

    let fields: [FormItem]
    weak var delegate: FormActionDelegate?

    init(fields: [FormItem]) {
        guard fields.count == ShippingAddressFormIndex.count else {
            fatalError("Invalid form definition for ShippingAddressFormInteractor")
        }
        self.fields = fields
        super.init()
        setTextFields(delegate: self)
    }

    fileprivate func setTextFields(delegate: UITextFieldDelegate?) {
        fields.forEach { $0.textField.delegate = delegate }
    }

    var result: ShippingAddress? {
        let text: [String] = fields.flatMap { $0.textField.text }.filter { $0.characters.count > 0 }
        guard text.count == ShippingAddressFormIndex.count else { return nil }
        return ShippingAddress(id: nil,
                               street: text[ShippingAddressFormIndex.street],
                               apartment: text[ShippingAddressFormIndex.apartmentNumber],
                               city: text[ShippingAddressFormIndex.city],
                               state: text[ShippingAddressFormIndex.state],
                               zipCode: text[ShippingAddressFormIndex.zipCode],
                               country: text[ShippingAddressFormIndex.country])

    }

    var status: ValidationStatus {
        let errorMessages: [String] = fields.flatMap {
            if case .invalid(let message) = $0.status {
                return message
            } else {
                return nil
            }
        }
        guard errorMessages.count > 0 else { return .valid }
        return .invalid(errorMessage: Constants.invalidData)
    }

}
