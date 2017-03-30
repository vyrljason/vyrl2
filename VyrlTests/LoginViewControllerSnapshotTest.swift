//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class LoginInteractorMock: LoginInteracting {
    weak var presenter: (ErrorAlertPresenting & ViewActivityPresenting)?
    func didPrepare(form: LoginFormInteracting) { }
    func didTapAction() { }
}

final class LoginViewControllerSnapshotTest: SnapshotTestCase {

    private var subject: LoginViewController!
    private var interactor: LoginInteractorMock!

    override func setUp() {
        super.setUp()
        interactor = LoginInteractorMock()
        subject = LoginViewController(interactor: interactor, formMaker: LoginFormFactory.self)

        recordMode = false
    }

    func testViewCorrect() {
        let _ = subject.view

        verifyForScreens(view: subject.view)
    }
}
