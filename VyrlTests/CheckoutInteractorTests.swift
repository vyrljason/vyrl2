//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class OrderProposalServiceMock: OrderProposalSending {
    var success = true
    var orders = Orders(orders: [])
    var error = ServiceError.unknown
    var didCallService = false

    func send(proposal: OrderProposal, completion: @escaping (Result<Orders, ServiceError>) -> Void) {
        didCallService = true
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

final class CheckoutNavigationMock: ShippingAddressViewPresenting, CheckoutSummaryViewPresenting, ContactInfoViewPresenting {
    var summaryPresented = false
    var shippingPresented = false
    var contactInfoPresented = false

    func presentSummaryView() {
        summaryPresented = true
    }

    func showShippingAdressView(using listener: ShippingAddressUpdateListening) {
        shippingPresented = true
    }

    func showContactInfoView(using listener: ContactInfoUpdateListening) {
        contactInfoPresented = true
    }
}

final class CheckoutInteractorTests: XCTestCase {
    private var projector: CheckoutRenderingMock!
    private var service: OrderProposalServiceMock!
    private var subject: CheckoutInteractor!
    private var navigation: CheckoutNavigationMock!
    private var errorPresenter: ErrorPresenterMock!
    private var cartStorage: CartStoringMock!

    override func setUp() {
        super.setUp()
        let cartData = CartData(products: [VyrlFaker.faker.product()], cartItems: [VyrlFaker.faker.cartItem()])
        projector = CheckoutRenderingMock()
        service = OrderProposalServiceMock()
        navigation = CheckoutNavigationMock()
        errorPresenter = ErrorPresenterMock()
        cartStorage = CartStoringMock()
        subject = CheckoutInteractor(cartData: cartData, service: service, cartStorage: cartStorage)
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

    func test_didTapContactInfo_callsNavigation() {
        subject.didTapContactInfo()

        XCTAssertTrue(navigation.contactInfoPresented)
    }

    func test_didUpdateContactInfo_callsNavigation() {
        projector.renderable = nil

        subject.didUpdate(contactInfo: VyrlFaker.faker.contactInfo())

        XCTAssertNotNil(projector.renderable)
    }

    func test_didUpdateShippingAddress_refreshesRenderable() {
        projector.renderable = nil

        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())

        XCTAssertNotNil(projector.renderable)
    }

    func test_didTapCheckout_whenShippingAddressPresentButNoContactInfo_presentsError() {
        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())
        subject.didUpdate(contactInfo: nil)

        subject.didTapCheckout()

        XCTAssertTrue(errorPresenter.didPresentError)
    }

    func test_didTapCheckout_whenContactInfoPresentButNoShippingAddress_presentsError() {
        subject.didUpdate(shippingAddress: nil)
        subject.didUpdate(contactInfo: VyrlFaker.faker.contactInfo())

        subject.didTapCheckout()

        XCTAssertTrue(errorPresenter.didPresentError)
    }

    func test_didTapCheckout_whenServiceReturnsError_presentsError() {
        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())
        subject.didUpdate(contactInfo: VyrlFaker.faker.contactInfo())
        service.success = false

        subject.didTapCheckout()

        XCTAssertTrue(service.didCallService)
        XCTAssertTrue(errorPresenter.didPresentError)
    }

    func test_didTapCheckout_whenServiceReturnsSuccess_callsPresenter() {
        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())
        subject.didUpdate(contactInfo: VyrlFaker.faker.contactInfo())

        subject.didTapCheckout()

        XCTAssertTrue(service.didCallService)
        XCTAssertTrue(navigation.summaryPresented)
    }

    func test_didTapCheckout_whenServiceReturnsSuccess_clearsCartStorage() {
        subject.didUpdate(shippingAddress: VyrlFaker.faker.shippingAddress())
        subject.didUpdate(contactInfo: VyrlFaker.faker.contactInfo())

        subject.didTapCheckout()

        XCTAssertTrue(service.didCallService)
        XCTAssertTrue(cartStorage.didCallClear)
    }
}
