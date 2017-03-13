//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ContactInfoInteractorMock: ContactInfoInteracting, FormActionDelegate {
    weak var listener: ContactInfoUpdateListening?
    weak var controller: ContactInfoControlling?
    weak var presenter: ErrorAlertPresenting?
    func didPrepare(form: ContactInfoFormInteracting) { }
    func didTapCancel() { }
    func didTapAction() { }
}

final class ContactInfoControllerSnapshotTest: SnapshotTestCase {

    private var subject: ContactInfoViewController!
    private var interactor: ContactInfoInteractorMock!

    override func setUp() {
        super.setUp()
        interactor = ContactInfoInteractorMock()
        subject = ContactInfoViewController(interactor: interactor, formFactory: ContactInfoFormFactory.self)
        
        recordMode = false
    }

    func testViewCorrect() {
        let _ = subject.view

        verifyForScreens(view: subject.view)
    }
}
