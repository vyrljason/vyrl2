//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CartItemCellSnapshotTest: SnapshotTestCase {

    let mockedProduct: Product = Product(title: "Leica",
                                         subTitle: "Custom-made by Jony Ive and Marc Newson",
                                         price: "$1,805,000",
                                         url: nil)

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let view = CartItemCell.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 122)

        view.render(mockedProduct.cartItemRenderable)

        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
