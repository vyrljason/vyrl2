//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import SlideMenuControllerSwift
@testable import Vyrl

final class LeftMenuInteractorTests: XCTestCase {

    var homeScreenPresentingMock: HomeScreenPresentingMock!
    var subject: LeftMenuInteractor!

    override func setUp() {
        super.setUp()
        homeScreenPresentingMock = HomeScreenPresentingMock()
        subject = LeftMenuInteractor()
        subject.delegate = homeScreenPresentingMock
    }

    func test_showHome_calledShowHome() {
        subject.didTapHome()

        XCTAssertTrue(homeScreenPresentingMock.showHomeCalled)
    }
}
