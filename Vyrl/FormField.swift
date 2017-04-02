//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol FormItemProtocol: class {
    unowned var textField: UITextField { get }
    var field: FormField { get }
    var status: ValidationStatus { get }
    weak var validityPresenter: ValidityIndicating? { set get }
    func clearError()
}

protocol ValidityIndicating: class {
    func presentValidation(status: ValidationStatus)
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
    case vyrlUsername
    case instagramUsername
    case password
    case nonEmpty
    case email

    var validator: FormFieldValidating {
        switch self {
        case .vyrlUsername: return VYRLUsernameValidation()
        case .instagramUsername: return InstagramUsernameValidation()
        case .password: return PasswordValidation()
        case .nonEmpty: return NonEmptyValidation()
        case .email: return EmailValidation()
        }
    }
}

final class FormItem: FormItemProtocol {

    let field: FormField
    private(set) unowned var textField: UITextField
    weak var validityPresenter: ValidityIndicating?

    var status: ValidationStatus {
        let formValidator = FormFieldValidator(validation: field.validator)
        let status: ValidationStatus
        if let errorMessage = formValidator.validationError(value: textField.text) {
            status = .invalid(errorMessage: errorMessage)
        } else {
            status = .valid
        }
        validityPresenter?.presentValidation(status: status)
        return status
    }

    init(field: FormField, textField: UITextField) {
        self.field = field
        self.textField = textField
    }

    init(field: FormField = .nonEmpty, formView: FormView) {
        self.field = field
        self.textField = formView.value
        self.validityPresenter = formView
    }

    func clearError() {
        validityPresenter?.presentValidation(status: .valid)
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
