//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class CheckoutRenderingMock: CheckoutRendering {

    var renderable: CheckoutRenderable?

    func render(_ renderable: CheckoutRenderable) {
        self.renderable = renderable
    }
}

final class CheckoutInteractorTests: XCTestCase {
    var projector: CheckoutRenderingMock!
    var subject: CheckoutInteractor!

    override func setUp() {
        super.setUp()
        let cartData = CartData(products: [VyrlFaker.faker.product()], cartItems: [VyrlFaker.faker.cartItem()])
        projector = CheckoutRenderingMock()
        subject = CheckoutInteractor(cartData: cartData)
        subject.projector = projector
    }

    func test_viewDidLoad_rendered() {
        subject.viewDidLoad()

        XCTAssertNotNil(projector.renderable)
    }
}
