//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ShippingAddressInteractorMock: ShippingAddressInteracting {
    weak var listener: ShippingAddressUpdateListening?
    weak var controller: ShippingAddressControlling?
    weak var presenter: ErrorAlertPresenting?
    func didPrepare(form: ShippingFormInteracting) { }
    func didTapCancel() { }
    func didTapAction() { }
}

final class ShippingAddressControllerSnapshotTest: SnapshotTestCase {

    private var subject: ShippingAddressViewController!
    private var interactor: ShippingAddressInteractorMock!

    override func setUp() {
        super.setUp()
        interactor = ShippingAddressInteractorMock()
        subject = ShippingAddressViewController(interactor: interactor, formFactory: ShippingAddressFormFactory.self)

        recordMode = false
    }

    func testViewCorrect() {
        let _ = subject.view

        verifyForScreens(view: subject.view)
    }
}
