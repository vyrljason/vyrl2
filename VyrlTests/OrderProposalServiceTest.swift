//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class OrderProposalServiceTest: XCTestCase {

    private var resourceController: APIResourceControllerMock<Orders>!
    private var subject: OrderProposalService!
    private var resource: OrderProposalResource!
    private var proposal: OrderProposal!

    override func setUp() {
        super.setUp()
        let cartItems: [CartItem] = [VyrlFaker.faker.cartItem(), VyrlFaker.faker.cartItem()]
        proposal = OrderProposal(products: cartItems, shippingAddress: VyrlFaker.faker.shippingAddress(), contactInfo: VyrlFaker.faker.contactInfo())
        resourceController = APIResourceControllerMock<Orders>()
        resourceController.result = Orders(orders: [VyrlFaker.faker.order()])
        resource = OrderProposalResource(controller: resourceController)
        let service = PostService<OrderProposalResource>(resource: resource)
        subject = OrderProposalService(resource: service)
    }

    func test_send_whenSuccess_returnsOrder() {
        resourceController.success = true

        var wasCalled = false
        subject.send(proposal: proposal) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getProducts_whenFailure_returnsError() {
        resourceController.success = false

        var wasCalled = false
        subject.send(proposal: proposal) { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
