//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ShippingAddresFormMock: ShippingFormInteracting {
    var delegate: FormActionDelegate?
    var result: ShippingAddress?
    var status: ValidationStatus = .valid
}

final class PresenterMock: ErrorAlertPresenting {
    var didPresentError = false

    func presentError(title: String?, message: String?) {
        didPresentError = true
    }
}

final class ControllerMock: ShippingAddressControlling {

    var shippingAddress: ShippingAddress?

    func finishPresentation(with shippingAddress: ShippingAddress?) {
        self.shippingAddress = shippingAddress
    }
}

final class ShippingAddressInteractorTest: XCTestCase {

    private var presenter: PresenterMock!
    private var controller: ControllerMock!
    private var form: ShippingAddresFormMock!
    private var subject: ShippingAddressInteractor!

    override func setUp() {
        super.setUp()
        presenter = PresenterMock()
        form = ShippingAddresFormMock()
        controller = ControllerMock()
        subject = ShippingAddressInteractor()
        subject.presenter = presenter
        subject.controller = controller
    }

    func test_didPrepare_setsFormDelegate() {
        subject.didPrepare(form: form)

        XCTAssertNotNil(form.delegate)
    }

    func test_didTapAction_whenFormIsInvalid_doesntCallServiceAndCallsErrorPresenter() {
        form.result = nil
        subject.didPrepare(form: form)
        form.status = .invalid(errorMessage: "message")

        subject.didTapAction()

        XCTAssertTrue(presenter.didPresentError)
    }

    func test_didTapAction_whenFormIsValid_controllerIsCalled() {
        subject.didPrepare(form: form)
        form.result = VyrlFaker.faker.shippingAddress()

        subject.didTapAction()

        XCTAssertEqual(controller.shippingAddress, form.result)
    }
}
