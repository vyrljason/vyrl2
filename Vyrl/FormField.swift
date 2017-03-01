//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol FormItemProtocol {
    unowned var textField: UITextField { get }
    var field: FormField { get }
    var status: ValidationStatus { get }
}

enum ValidationStatus {
    case valid
    case invalid(errorMessage: String)
}

extension ValidationStatus: Equatable { }

func == (lhs: ValidationStatus, rhs: ValidationStatus) -> Bool {
    switch (lhs, rhs) {
        case (.valid, .valid),
             (.invalid, .invalid):
        return true
    default:
        return false
    }
}

enum FormField {
    case username
    case password

    var validator: FormFieldValidating {
        switch self {
        case .username: return UsernameValidation()
        case .password: return PasswordValidation()
        }
    }
}

final class FormItem: FormItemProtocol {

    let field: FormField
    private(set) unowned var textField: UITextField

    var status: ValidationStatus {
        let formValidator = FormFieldValidator(validation: field.validator)
        if let errorMessage = formValidator.validationError(value: textField.text) {
            return .invalid(errorMessage: errorMessage)
        } else {
            return .valid
        }
    }

    init(field: FormField, textField: UITextField) {
        self.field = field
        self.textField = textField
    }
}

func == (lhs: FormItem, rhs: FormItem) -> Bool {
    return lhs.field == rhs.field && lhs.textField == rhs.textField
}

extension FormItem: Hashable {
    var hashValue: Int {
        return field.hashValue ^ textField.hashValue
    }
}
