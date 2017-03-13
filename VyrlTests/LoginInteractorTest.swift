//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class LoginFormMock: LoginFormInteracting {
    var delegate: FormActionDelegate?
    var result: UserCredentials?
    var status: ValidationStatus = .valid
}

final class AuthorizationListenerMock: AuthorizationListener {
    var didCallFinish = false

    func didFinishAuthorizing() {
        didCallFinish = true
    }
}

final class LoginPresenterMock: ErrorAlertPresenting, ViewActivityPresenting {
    var didPresentError = false
    var didPresentActivity = false
    var didDismissActivity = false

    func presentActivity() {
        didPresentActivity = true
    }

    func dismiss() {
        didDismissActivity = true
    }

    func presentError(title: String?, message: String?) {
        didPresentError = true
    }
}

final class LoginInteractorTest: XCTestCase {

    private var service: LoginServiceMock!
    private var presenter: LoginPresenterMock!
    private var form: LoginFormMock!
    private var subject: LoginInteractor!
    private var formItem: FormItem!
    private var listener: AuthorizationListenerMock!
    private var credentialsStorage: CredentialStorageMock!

    override func setUp() {
        super.setUp()
        service = LoginServiceMock()
        presenter = LoginPresenterMock()
        form = LoginFormMock()
        listener = AuthorizationListenerMock()
        credentialsStorage = CredentialStorageMock()
        formItem = FormItem(field: .username, textField: MockTextField())
        subject = LoginInteractor(service: service, credentialsStorage: credentialsStorage)
        subject.presenter = presenter
        subject.listener = listener
    }

    func test_didPrepare_setsFormDelegate() {
        subject.didPrepare(form: form)

        XCTAssertNotNil(form.delegate)
    }

    func test_didTapAction_whenFormIsInvalid_doesntCallServiceAndCallsErrorPresenter() {
        form.result = UserCredentials(username: "username", password: "password")
        subject.didPrepare(form: form)
        form.status = .invalid(errorMessage: "message")

        subject.didTapAction()

        XCTAssertFalse(service.didCalledService)
        XCTAssertTrue(presenter.didPresentError)
    }

    func test_didTapAction_whenFormIsValid_callsService_withSameUserCredentials() {
        subject.didPrepare(form: form)
        form.result = UserCredentials(username: "username", password: "password")

        subject.didTapAction()

        XCTAssertTrue(service.didCalledService)
        XCTAssertEqual(service.credentials, form.result)
    }

    func test_didTapAction_whenFormIsValid_savesCredentials() {
        subject.didPrepare(form: form)
        form.result = UserCredentials(username: "username", password: "password")

        subject.didTapAction()

        XCTAssertEqual(service.result.token, credentialsStorage.accessToken)
    }

    func test_didTapAction_whenFormIsValid_whenServiceReturnsFailure_PresentsError() {
        service.success = false
        subject.didPrepare(form: form)
        form.result = UserCredentials(username: "username", password: "password")

        subject.didTapAction()
        
        XCTAssertTrue(service.didCalledService)
        XCTAssertTrue(presenter.didPresentError)
    }
}
