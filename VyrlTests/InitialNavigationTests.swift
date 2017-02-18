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
    private var mainNavigation: NavigationControllerMock!
    private var cart: UIViewController!
    private var chat: UIViewController!
    private var leftMenu: LeftMenuViewController!
    private var interactor: InitialNavigationInteractor!

    override func setUp() {
        super.setUp()
        window = WindowMock()
        mainView = UIViewController()
        mainNavigation = NavigationControllerMock()
        chat = UIViewController()
        cart = UIViewController()
        leftMenu = LeftMenuViewController()
        interactor = InitialNavigationInteractor()
        subject = InitialNavigationFactory.make(interactor: interactor,
                                                mainView: mainView,
                                                mainNavigation: mainNavigation,
                                                leftMenu: leftMenu,
                                                cart: cart,
                                                chat: chat,
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

    func test_showsCart() {
        subject.showInitialViewController()
        subject.showCart()

        guard let navigation = mainNavigation.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first === cart)
    }

    func test_showsChat() {
        subject.showInitialViewController()
        subject.showChat()

        guard let navigation = mainNavigation.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first === chat)
    }

    func test_dismissed() {
        subject.showInitialViewController()
        subject.dismissModal()

        XCTAssertTrue(mainNavigation.dismissed)
    }
}
