//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol SignUpFormInteracting: class, FormInteracting {
    var result: UserSignUpRequest? { get }
}

private enum Constants {
    static let emailsDontMatchError = NSLocalizedString("signUp.error.emailsDontMatch", comment: "")
    static let invalidFormError = NSLocalizedString("signUp.error.invalidForm", comment: "")

}

enum SignUpFormIndex: Int, CustomIntegerConvertible {
    case username
    case email
    case emailConfirmation
    case password
    case instagramUsername

    var integerValue: Int {
        return rawValue
    }

    static var count: Int {
        let lastElement = SignUpFormIndex.instagramUsername
        return lastElement.integerValue + 1
    }
}

final class SignUpFormInteractor: SignUpFormInteracting {

    let fieldsInteractor: FormFieldsInteracting

    init(fieldsInteractor: FormFieldsInteracting) {
        self.fieldsInteractor = fieldsInteractor
    }

    var result: UserSignUpRequest? {
        let text: [String] = fieldsInteractor.fields.flatMap { $0.textField.text }.filter { $0.characters.count > 0 }
        guard text.count == SignUpFormIndex.count else { return nil }
        return UserSignUpRequest(username: text[SignUpFormIndex.username.integerValue],
                                 email: text[SignUpFormIndex.email],
                                 password: text[SignUpFormIndex.password],
                                 platformUsername: text[SignUpFormIndex.instagramUsername])
    }

    var status: ValidationStatus {
        let errorMessages: [String] = fieldsInteractor.fields.flatMap {
            if case .invalid(let message) = $0.status {
                return message
            } else {
                return nil
            }
        }
        //TODO: check e-mail & e-mail confirmations match
        guard fieldsInteractor.fields[SignUpFormIndex.email].textField.text == fieldsInteractor.fields[SignUpFormIndex.emailConfirmation].textField.text else {
            return .invalid(errorMessage: Constants.emailsDontMatchError)
        }
        guard errorMessages.count > 0 else { return .valid }
        return .invalid(errorMessage: Constants.invalidFormError)
    }
}
