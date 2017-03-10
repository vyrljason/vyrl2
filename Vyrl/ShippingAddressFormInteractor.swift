//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let invalidData = NSLocalizedString("shippingAddress.error.invalid", comment: "")
}

protocol ShippingFormInteracting: class {
    weak var delegate: FormActionDelegate? { get set }
    var result: ShippingAddress? { get }
    var status: ValidationStatus { get }
}

enum ShippingAddressFormIndex: Int {
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

    fileprivate let fields: [FormItem]
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
                               street: text[ShippingAddressFormIndex.street.integerValue],
                               apartment: text[ShippingAddressFormIndex.apartmentNumber.integerValue],
                               city: text[ShippingAddressFormIndex.city.integerValue],
                               state: text[ShippingAddressFormIndex.state.integerValue],
                               zipCode: text[ShippingAddressFormIndex.zipCode.integerValue],
                               country: text[ShippingAddressFormIndex.country.integerValue])

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

    fileprivate func next(textField: UITextField) -> UITextField? {
        guard let relatedFormItem = fields.filter({ $0.textField == textField }).first else { return nil }
        return fields.after(item: relatedFormItem)?.textField
    }
}

extension ShippingAddressFormInteractor: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = next(textField: textField) {
            nextTextField.becomeFirstResponder()
        } else {
            delegate?.didTapAction()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let relatedFormItem = fields.filter({ $0.textField == textField }).first else { return true }

        var updatedString: NSString? = textField.text as NSString?
        updatedString = updatedString?.replacingCharacters(in: range, with: string) as NSString?
        textField.text = updatedString as String?

        _ = relatedFormItem.status
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let relatedFormItem = fields.filter({ $0.textField == textField }).first else { return }
        relatedFormItem.clearError()
    }
}
