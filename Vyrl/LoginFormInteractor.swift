//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol LoginFormInteracting: class {
    weak var delegate: FormActionDelegate? { get set }
    var result: UserCredentials? { get }
    var status: ValidationStatus { get }
}

protocol FormActionDelegate: class {
    func didTapAction()
}

final class LoginFormInteractor: NSObject, LoginFormInteracting {

    private let fields: [FormField]
    fileprivate let username: FormItem
    fileprivate let password: FormItem
    weak var delegate: FormActionDelegate?

    init(username: FormItem, password: FormItem) {
        guard username.field == .vyrlUsername, password.field == .password else {
            fatalError("Invalid form definition for LoginForm")
        }
        self.fields = [.vyrlUsername, .password]
        self.username = username
        self.password = password
        super.init()
        self.username.textField.delegate = self
        self.password.textField.delegate = self
    }

    var result: UserCredentials? {
        guard let username = username.textField.text, username.characters.count > 0,
            let password = password.textField.text, password.characters.count > 0 else { return nil }
        return UserCredentials(username: username, password: password)
    }

    var status: ValidationStatus {
        let errorMessages: [String] = [username, password].flatMap {
            if case .invalid(let message) = $0.status {
                return message
            } else {
                return nil
            }
        }
        guard errorMessages.count > 0 else { return .valid }
        return .invalid(errorMessage: errorMessages.joined(separator: "\n"))
    }
}

extension LoginFormInteractor: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if username.textField == textField {
            password.textField.becomeFirstResponder()
        }
        if password.textField == textField {
            delegate?.didTapAction()
        }
        return true
    }

}
