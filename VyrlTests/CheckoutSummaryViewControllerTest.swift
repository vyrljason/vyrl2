//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CheckoutSummaryInteractorMock: CheckoutSummaryInteracting {
    weak var navigation: CheckoutNavigationDismissing & ChatPresenting?
    func didTapGoToCollabs() { }
}

final class CheckoutSummaryViewSnapshotTest: SnapshotTestCase {

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let interactor = CheckoutSummaryInteractorMock()
        let view = CheckoutSummaryViewController(interactor: interactor)
        let _ = view.view

        verifyForScreens(view: view.view)
    }
}
