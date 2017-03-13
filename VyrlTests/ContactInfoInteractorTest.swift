//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ContactInfoFormMock: NSObject, ContactInfoFormInteracting {
    var fields = [FormItem]()
    var delegate: FormActionDelegate?
    var result: ContactInfo?
    var status: ValidationStatus = .valid
}

final class ContactInfoControllerMock: ContactInfoControlling {

    var contactInfo: ContactInfo?
    var didCallFinishPresentation = false

    func finishPresentation(with contactInfo: ContactInfo?) {
        didCallFinishPresentation = true
        self.contactInfo = contactInfo
    }
}

final class ContactInfoUpdateListenerMock: ContactInfoUpdateListening {

    var lastContactInfo: ContactInfo?
    var didCallUpdate = false

    func didUpdate(contactInfo: ContactInfo?) {
        didCallUpdate = true
        lastContactInfo = contactInfo
    }
}

final class ContactInfoInteractorTest: XCTestCase {

    private var listener: ContactInfoUpdateListenerMock!
    private var presenter: ErrorPresenterMock!
    private var controller: ContactInfoControllerMock!
    private var form: ContactInfoFormMock!
    private var subject: ContactInfoInteractor!

    override func setUp() {
        super.setUp()
        listener = ContactInfoUpdateListenerMock()
        presenter = ErrorPresenterMock()
        form = ContactInfoFormMock()
        controller = ContactInfoControllerMock()
        subject = ContactInfoInteractor()
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
        XCTAssertNil(controller.contactInfo)
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
        form.result = VyrlFaker.faker.contactInfo()

        subject.didTapAction()

        XCTAssertEqual(controller.contactInfo, form.result)
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
        form.result = VyrlFaker.faker.contactInfo()

        subject.didTapAction()
        
        XCTAssertTrue(listener.didCallUpdate)
        XCTAssertNotNil(listener.lastContactInfo)
    }
}
