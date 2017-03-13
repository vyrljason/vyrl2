//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let emptyError = NSLocalizedString("validation.error.textFieldEmpty", comment: "")
    static let usernameError = NSLocalizedString("validation.error.usernameEmpty", comment: "")
    static let passwordInvalidError = NSLocalizedString("validation.error.passwordInvalid", comment: "")
    static let emailError = NSLocalizedString("validation.error.invalidEmail", comment: "")
}

final class FormFieldValidator {
    let typeValidation: FormFieldValidating

    init(validation: FormFieldValidating) {
        typeValidation = validation
    }

    func validationError(value: String?) -> String? {
        return typeValidation.validate(value: value) ? nil : typeValidation.validationError
    }
}

protocol FormFieldValidating {
    var validationError: String { get }
    func validate(value: String?) -> Bool
}

struct PasswordValidation: FormFieldValidating {
    let validationError: String = Constants.passwordInvalidError

    func validate(value: String?) -> Bool {
        guard let value = value, value.characters.count > 0 else { return false }
        return value.isValidPassword
    }
}

struct UsernameValidation: FormFieldValidating {
    let validationError: String = Constants.usernameError

    func validate(value: String?) -> Bool {
        guard let value = value else { return false }
        return value.characters.count > 0
    }
}

struct NonEmptyValidation: FormFieldValidating {
    let validationError: String = Constants.emptyError

    func validate(value: String?) -> Bool {
        guard let value = value else { return false }
        return value.characters.count > 0
    }
}

struct EmailValidation: FormFieldValidating {
    let validationError: String = Constants.emailError

    func validate(value: String?) -> Bool {
        guard let value = value else { return false }
        return value.isEmail
    }
}
