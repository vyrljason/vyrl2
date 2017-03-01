//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private enum Constants {
    static let usernameError = NSLocalizedString("validation.error.usernameEmpty", comment: "")
    static let passwordEmptyError = NSLocalizedString("validation.error.passwordEmpty", comment: "")
    static let passwordInvalidError = NSLocalizedString("validation.error.passwordInvalid", comment: "")
}

final class FormFieldValidator {
    let typeValidation: FormFieldValidating

    init(validation: FormFieldValidating) {
        typeValidation = validation
    }

    func validationError(value: String?) -> String? {
        return typeValidation.validationError(value: value)
    }
}

protocol FormFieldValidating {
    func validationError(value: String?) -> String?
}

struct PasswordValidation: FormFieldValidating {
    func validationError(value: String?) -> String? {
        guard let value = value, value.characters.count > 0 else { return Constants.passwordEmptyError }
        guard value.isValidPassword else { return Constants.passwordInvalidError }
        return nil
    }
}

struct UsernameValidation: FormFieldValidating {
    func validationError(value: String?) -> String? {
        guard let value = value, value.characters.count > 0 else { return Constants.usernameError }
        return nil
    }
}
