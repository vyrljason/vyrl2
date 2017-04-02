//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CheckoutInteractorMock: CheckoutInteracting {
    weak var projector: (CheckoutRendering & ActionButtonRendering)?
    weak var navigation: (ShippingAddressViewPresenting & ContactInfoViewPresenting & CheckoutSummaryViewPresenting)?
    weak var errorPresenter: ErrorAlertPresenting?
    func viewDidLoad() { }
    func didTapAddShippingAddress() { }
    func didUpdate(shippingAddress: ShippingAddress?) { }
    func didTapCheckout() { }
    func didTapContactInfo() { }
    func didUpdate(contactInfo: ContactInfo?) { }
}

final class CheckoutViewControllerSnapshotTest: SnapshotTestCase {

    private var interactor: CheckoutInteractorMock!
    private var subject: CheckoutViewController!
    private var agreement = NSAttributedString(string: "Semper crescis, aut decrescis Semper crescis, aut decrescis Semper crescis, aut decrescis Semper crescis, aut decrescis Semper crescis, aut decrescis", attributes: StyleKit.infoViewAttributes)

    override func setUp() {
        super.setUp()
        interactor = CheckoutInteractorMock()
        subject = CheckoutViewController(interactor: interactor)
        recordMode = false
    }

    func testViewCorrect_noShippingAddress_noContactInfo() {
        let contactRenderable = ActionDescriptionRenderable(isActionAvailable: true, description: nil, isDescriptionLabelVisible: false)
        let shippingAddressRenderable = ActionDescriptionRenderable(isActionAvailable: true, description: nil, isDescriptionLabelVisible: false)
        let checkoutRenderable = CheckoutRenderable(summaryHead: "O Fortuna", summarySubHead: "velut Luna", agreement: agreement, contact: contactRenderable, shippingAddress: shippingAddressRenderable)
        let actionRenderable = ActionButtonRenderable(state: .disabled)
        let _ = subject.view

        subject.render(checkoutRenderable)
        subject.render(actionRenderable)

        verifyForScreens(view: subject.view)
    }

    func testViewCorrect_withShippingAddress_noContactInfo() {
        let contactRenderable = ActionDescriptionRenderable(isActionAvailable: true, description: nil, isDescriptionLabelVisible: false)
        let shippingAddressRenderable = ActionDescriptionRenderable(isActionAvailable: false, description: "Street, nr 20, City, \nState, ZipCode, Country", isDescriptionLabelVisible: true)
        let checkoutRenderable = CheckoutRenderable(summaryHead: "O Fortuna", summarySubHead: "velut Luna", agreement: agreement, contact: contactRenderable, shippingAddress: shippingAddressRenderable)
        let actionRenderable = ActionButtonRenderable(state: .disabled)
        let _ = subject.view

        subject.render(checkoutRenderable)
        subject.render(actionRenderable)

        verifyForScreens(view: subject.view)
    }

    func testViewCorrect_noShippingAddress_withContactInfo() {
        let contactRenderable = ActionDescriptionRenderable(isActionAvailable: false, description: "First last name \nsome@email.com", isDescriptionLabelVisible: true)
        let shippingAddressRenderable = ActionDescriptionRenderable(isActionAvailable: true, description: nil, isDescriptionLabelVisible: false)
        let checkoutRenderable = CheckoutRenderable(summaryHead: "O Fortuna", summarySubHead: "velut Luna", agreement: agreement, contact: contactRenderable, shippingAddress: shippingAddressRenderable)
        let actionRenderable = ActionButtonRenderable(state: .disabled)
        let _ = subject.view

        subject.render(checkoutRenderable)
        subject.render(actionRenderable)

        verifyForScreens(view: subject.view)
    }

    func testViewCorrect_ShippingAddress_withContactInfo() {
        let contactRenderable = ActionDescriptionRenderable(isActionAvailable: false, description: "First last name \nsome@email.com", isDescriptionLabelVisible: true)
        let shippingAddressRenderable = ActionDescriptionRenderable(isActionAvailable: false, description: "Street, nr 20, City, \nState, ZipCode, Country", isDescriptionLabelVisible: true)
        let checkoutRenderable = CheckoutRenderable(summaryHead: "O Fortuna", summarySubHead: "velut Luna", agreement: agreement, contact: contactRenderable, shippingAddress: shippingAddressRenderable)
        let actionRenderable = ActionButtonRenderable(state: .enabled)
        let _ = subject.view

        subject.render(checkoutRenderable)
        subject.render(actionRenderable)

        verifyForScreens(view: subject.view)
    }

    func testViewCorrect_ShippingAddress_withContactInfo_inProgress() {
        let contactRenderable = ActionDescriptionRenderable(isActionAvailable: false, description: "First last name \nsome@email.com", isDescriptionLabelVisible: true)
        let shippingAddressRenderable = ActionDescriptionRenderable(isActionAvailable: false, description: "Street, nr 20, City, \nState, ZipCode, Country", isDescriptionLabelVisible: true)
        let checkoutRenderable = CheckoutRenderable(summaryHead: "O Fortuna", summarySubHead: "velut Luna", agreement: agreement, contact: contactRenderable, shippingAddress: shippingAddressRenderable)
        let actionRenderable = ActionButtonRenderable(state: .inProgress)
        let _ = subject.view

        subject.render(checkoutRenderable)
        subject.render(actionRenderable)

        verifyForScreens(view: subject.view)
    }
}
