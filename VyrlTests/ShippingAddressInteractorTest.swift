//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ShippingAddresFormMock: NSObject, ShippingFormInteracting {
    var fields = [FormItem]()
    var delegate: FormActionDelegate?
    var result: ShippingAddress?
    var status: ValidationStatus = .valid
}

final class ControllerMock: ShippingAddressControlling {

    var shippingAddress: ShippingAddress?
    var didCallFinishPresentation = false

    func finishPresentation(with shippingAddress: ShippingAddress?) {
        didCallFinishPresentation = true
        self.shippingAddress = shippingAddress
    }
}

final class ShippingAddressUpdateListenerMock: ShippingAddressUpdateListening {

    var lastShippingAddress: ShippingAddress?
    var didCallUpdate = false

    func didUpdate(shippingAddress: ShippingAddress?) {
        didCallUpdate = true
        lastShippingAddress = shippingAddress
    }
}

final class ShippingAddressInteractorTest: XCTestCase {

    private var listener: ShippingAddressUpdateListenerMock!
    private var presenter: ErrorPresenterMock!
    private var controller: ControllerMock!
    private var form: ShippingAddresFormMock!
    private var subject: ShippingAddressInteractor!

    override func setUp() {
        super.setUp()
        listener = ShippingAddressUpdateListenerMock()
        presenter = ErrorPresenterMock()
        form = ShippingAddresFormMock()
        controller = ControllerMock()
        subject = ShippingAddressInteractor()
        subject.presenter = presenter
        subject.controller = controller
        subject.listener = listener
    }

    func test_didPrepare_setsFormDelegate() {
        subject.didPrepare(form: form)

        XCTAssertNotNil(form.delegate)
    }

    func test_didTapCancel_callsControllerWithNoShippingAddress() {
        subject.didTapCancel()

        XCTAssertTrue(controller.didCallFinishPresentation)
        XCTAssertNil(controller.shippingAddress)
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

    func test_didTapAction_whenFormIsInvalid_doesntCallListener() {
        form.result = nil
        subject.didPrepare(form: form)
        form.status = .invalid(errorMessage: "message")

        subject.didTapAction()

        XCTAssertFalse(listener.didCallUpdate)
    }

    func test_didTapAction_whenFormIsValid_listenerIsCalledWithShippingAddress() {
        subject.didPrepare(form: form)
        form.result = VyrlFaker.faker.shippingAddress()

        subject.didTapAction()

        XCTAssertTrue(listener.didCallUpdate)
        XCTAssertNotNil(listener.lastShippingAddress)
    }
}
