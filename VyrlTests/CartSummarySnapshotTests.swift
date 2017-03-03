//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CartInteractingMock: CartInteracting {
    weak var projector: CartSummaryRendering & ViewContainer & LayoutGuideHaving?

    var product: Product?

    func viewDidAppear() { }
    func use(_ tableView: UITableView) { }
    
    func showGuidelines(for product: Product) {
        self.product = product
    }
}

final class CartSummarySnapshotTest: SnapshotTestCase {

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let interactor = CartInteractingMock()
        let view = CartViewController(interactor: interactor)
        let renderable = CartSummaryRenderable(from: CartSummary(productsCount: 7,
                                                                 brandsCount: 7,
                                                                 value: 777))
        let _ = view.view
        view.render(renderable)
        verifyForScreens(view: view.view)
    }
}
