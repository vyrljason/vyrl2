//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import SlideMenuControllerSwift
@testable import Vyrl

final class InitialNavigationTests: XCTestCase {
    private var subject: InitialNavigation!
    private var window: WindowMock!

    private var mainView: UIViewController!
    private var leftMenu: LeftMenuViewController!

    override func setUp() {
        super.setUp()
        window = WindowMock()
        mainView = UIViewController()
        leftMenu = LeftMenuViewController()
        subject = InitialNavigationFactory.make(mainView: mainView,
                                                leftMenu: leftMenu,
                                                cart: UIViewController(),
                                                chat: UIViewController(),
                                                window: window)
    }

    func test_showsSlideMenuController() {
        subject.showInitialViewController()
        XCTAssertTrue(window.setRootViewController! is SlideMenuController)
    }

    func test_slideMenuHasCorrectViewControllers() {
        subject.showInitialViewController()

        guard let menu = window.setRootViewController as? SlideMenuController else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(menu.leftViewController === leftMenu)

        guard let navigation = menu.mainViewController as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first === mainView)
    }
}
