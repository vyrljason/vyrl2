//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
import Alamofire
@testable import Vyrl

final class OrderProposalResourceTest: BaseAPIResourceTest {

    private var subject: OrderProposalResource!
    private var proposal: OrderProposal!

    override func setUp() {
        super.setUp()
        let cartItems: [CartItem] = [VyrlFaker.faker.cartItem(), VyrlFaker.faker.cartItem()]
        proposal = OrderProposal(products: cartItems, shippingAddress: VyrlFaker.faker.shippingAddress(), contactInfo: VyrlFaker.faker.contactInfo())
        subject = OrderProposalResource(controller: controller)
    }

    func test_send_callProperEndpoint() {
        let endpoint = OrderProposalEndpoint(proposal: proposal)

        subject.post(using: proposal) { _ in }

        assertDidCallTo(endpoint)
    }
}
