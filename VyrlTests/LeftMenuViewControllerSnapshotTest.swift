//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class LeftMenuViewControllerSnapshotTest: SnapshotTestCase {
    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let leftMenuInteractor = LeftMenuInteractingMock()
        let leftMenu = LeftMenuViewController(interactor: leftMenuInteractor)

        verifyForScreens(view: leftMenu.view)
    }
}
