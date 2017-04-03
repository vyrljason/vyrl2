//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class FormActionDelegateMock: FormActionDelegate {

    var didCallAction = false

    func didTapAction() {
        didCallAction = true
    }
}

final class MockTextField: UITextField {
    var didBecomeFirstResponder = false

    override func becomeFirstResponder() -> Bool {
        didBecomeFirstResponder = true
        return super.becomeFirstResponder()
    }
}

final class LoginFormInteractorTest: XCTestCase {

    private var usernameTextField: MockTextField!
    private var passwordTextField: MockTextField!
    private var usernameItem: FormItem!
    private var passwordItem: FormItem!
    private var username = "username"
    private var password = "PAssw00rd"
    private var actionListener: FormActionDelegateMock!

    private var subject: LoginFormInteractor!

    override func setUp() {
        super.setUp()
        actionListener = FormActionDelegateMock()
        usernameTextField = MockTextField()
        passwordTextField = MockTextField()
        usernameItem = FormItem(field: .vyrlUsername, textField: usernameTextField)
        passwordItem = FormItem(field: .password, textField: passwordTextField)

        subject = LoginFormInteractor(username: usernameItem, password: passwordItem)
        subject.delegate = actionListener
    }

    private func injectValidFormData() {
        usernameTextField.text = username
        passwordTextField.text = password
    }

    func test_init_TextDelegtesAreSet() {
        let textFields: [UITextField] = [usernameTextField, passwordTextField]
        textFields.forEach { XCTAssertTrue($0.delegate === subject) }
    }

    func test_formResult_ReturnsTextFieldValues() {
        injectValidFormData()
        let expected = UserCredentials(username: username, password: password)

        XCTAssertEqual(subject.result, expected)
    }

    func test_formResult_WithNoUsername_IsNil() {
        injectValidFormData()
        usernameTextField.text = nil

        XCTAssertNil(subject.result)
    }

    func test_formResult_WithNoUsername_isInvalid() {
        injectValidFormData()
        let expectedStatus = ValidationStatus.invalid(errorMessage: "message")
        usernameTextField.text = nil

        XCTAssertEqual(subject.status, expectedStatus)
    }

    func test_formResult_WithNoUsername_returnsErrorMessage() {
        injectValidFormData()
        let expectedStatus = ValidationStatus.invalid(errorMessage: "message")
        usernameTextField.text = nil

        XCTAssertEqual(subject.status, expectedStatus)
    }

    func test_formResult_WithInvalidPassword_isInvalid() {
        injectValidFormData()
        let expectedStatus = ValidationStatus.invalid(errorMessage: "message")
        passwordTextField.text = "pass"

        XCTAssertEqual(subject.status, expectedStatus)
    }

    func test_textFieldShouldReturn_whenNextFormFieldIsAvailable_changesFirstResponder() {
        injectValidFormData()

        _ = subject.textFieldShouldReturn(usernameTextField)

        XCTAssertTrue(passwordTextField.didBecomeFirstResponder)
    }

    func test_textFieldShouldReturn_whenLastFormField_callsActionDelegate() {
        injectValidFormData()

        _ = subject.textFieldShouldReturn(passwordTextField)

        XCTAssertTrue(actionListener.didCallAction)
    }
}
