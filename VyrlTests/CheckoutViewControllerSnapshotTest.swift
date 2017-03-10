//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CheckoutInteractorMock: CheckoutInteracting {
    weak var projector: CheckoutRendering?
    weak var navigation: ShippingAddressViewPresenting?
    func viewDidLoad() { }
    func didTapAddShippingAddress() { }
    func didUpdate(shippingAddress: ShippingAddress?) { }
}

final class CheckoutViewControllerSnapshotTest: SnapshotTestCase {

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let interactor = CheckoutInteractorMock()
        let view = CheckoutViewController(interactor: interactor)
        let agreement = NSAttributedString(string: "Semper crescis, aut decrescis Semper crescis, aut decrescis Semper crescis, aut decrescis Semper crescis, aut decrescis Semper crescis, aut decrescis", attributes: StyleKit.infoViewAttributes)
        let renderable = CheckoutRenderable(summaryHead: "O Fortuna",
                                            summarySubHead: "velut Luna ",
                                            address: "Semper crescis\naut decrescis",
                                            addressButtonVisible: false,
                                            contact: "Nunc obdurat\net tunc curat",
                                            agreement: agreement,
                                            checkoutButtonVisible: true)
        let _ = view.view
        view.render(renderable)
        verifyForScreens(view: view.view)
    }
}
