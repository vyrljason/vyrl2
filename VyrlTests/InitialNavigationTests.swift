//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class InitialNavigationTests: XCTestCase {
    private var subject: InitialNavigation!
    private var window: WindowMock!

    override func setUp() {
        super.setUp()
        window = WindowMock()
        subject = InitialNavigation(window: window)
    }

    func test_runsIntroduction() {
        subject.showInitialViewController()
        XCTAssertTrue(window.setRootViewController! is ViewController)
    }
}
