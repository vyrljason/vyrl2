//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import SlideMenuControllerSwift
@testable import Vyrl

final class LeftMenuInteractorTests: XCTestCase {

    private var homeScreenPresentingMock: HomeScreenPresentingMock!
    private var subject: LeftMenuInteractor!
    private var dataSource: DataSourceMock!

    override func setUp() {
        super.setUp()
        homeScreenPresentingMock = HomeScreenPresentingMock()
        dataSource = DataSourceMock()
        subject = LeftMenuInteractor(dataSource: dataSource)
        subject.delegate = homeScreenPresentingMock
    }

    func test_showHome_calledShowHome() {
        subject.didTapHome()

        XCTAssertTrue(homeScreenPresentingMock.showHomeCalled)
    }
}
