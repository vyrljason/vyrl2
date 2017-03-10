//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class OrderProposalServiceMock: OrderProposalSending {
    var success = true
    var orders = Orders(orders: [])
    var error = ServiceError.unknown

    func send(proposal: OrderProposal, completion: @escaping (Result<Orders, ServiceError>) -> Void) {
        if success {
            completion(.success(orders))
        } else {
            completion(.failure(error))
        }
    }
}

final class CheckoutRenderingMock: CheckoutRendering {
    var renderable: CheckoutRenderable?

    func render(_ renderable: CheckoutRenderable) {
        self.renderable = renderable
    }
}

final class CheckoutNavigationMock: ShippingAddressViewPresenting, CheckoutSummaryViewPresenting {
    var summaryPresented = false
    var shippingPresented = false

    func presentSummaryView() {
        summaryPresented = true
    }

    func showShippingAdressView() {
        shippingPresented = true
    }
}

final class CheckoutInteractorTests: XCTestCase {
    var projector: CheckoutRenderingMock!
    var service: OrderProposalServiceMock!
    var subject: CheckoutInteractor!
    var navigation: CheckoutNavigationMock!
    var errorPresenter: ErrorPresenterMock!

    override func setUp() {
        super.setUp()
        let cartData = CartData(products: [VyrlFaker.faker.product()], cartItems: [VyrlFaker.faker.cartItem()])
        projector = CheckoutRenderingMock()
        service = OrderProposalServiceMock()
        navigation = CheckoutNavigationMock()
        errorPresenter = ErrorPresenterMock()
        subject = CheckoutInteractor(cartData: cartData, service: service)
        subject.projector = projector
        subject.navigation = navigation
        subject.errorPresenter = errorPresenter
    }

     func test_viewDidLoad_rendered() {
        subject.viewDidLoad()

        XCTAssertNotNil(projector.renderable)
    }

    func test_didTapShippingAddress_callsNavigation() {
        subject.didTapAddShippingAddress()

        XCTAssertTrue(navigation.shippingPresented)
    }

    func test_didUpdateShippingAddress_refreshesRenderable() {
        projector.renderable = nil

        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())

        XCTAssertNotNil(projector.renderable)
    }

    func test_didTapCheckout_whenNoShippingAddress_presentsError() {
        subject.didUpdate(shippingAddress: nil)

        subject.didTapCheckout()

        XCTAssertTrue(errorPresenter.didPresentError)
    }

    func test_didTapCheckout_whenServiceReturnsError_presentsError() {
        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())
        service.success = false

        subject.didTapCheckout()

        XCTAssertTrue(errorPresenter.didPresentError)
    }

    func test_didTapCheckout_whenServiceReturnsError_callsPresenter() {
        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())

        subject.didTapCheckout()

        XCTAssertTrue(navigation.summaryPresented)
    }
}
