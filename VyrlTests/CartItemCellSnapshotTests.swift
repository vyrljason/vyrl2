//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CartItemCellSnapshotTest: SnapshotTestCase {

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let view = CartItemCell.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 120)

        let cartItemRenderable: CartItemCellRenderable = CartItemCellRenderable(title: "Leica",
                                                                                subTitle: "- lens: Voigtlander 40mm F1.4\n- model: R8",
                                                                                price: "$1,805,000")

        view.render(cartItemRenderable)

        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
