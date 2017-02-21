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
        leftMenu = LeftMenuViewController(interactor: LeftMenuInteractor())
        interactor = InitialNavigationInteractor()
        
        let builder = InitialNavigationBuilder()
        builder.interactor = interactor
        builder.mainView = mainView
        builder.mainNavigation = mainNavigation
        builder.leftMenu = leftMenu
        builder.cart = cart
        builder.chat = chat
        builder.window = window

        subject = builder.build()
    }

    func test_showInitialViewController_showsSlideMenuController() {
        subject.showInitialViewController()
        XCTAssertTrue(window.setRootViewController! is SlideMenuController)
    }

    func test_showInitialViewController_slideMenuHasCorrectViewControllers() {
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

    func test_showCart_showsCart() {
        subject.showInitialViewController()
        subject.showCart()

        guard let navigation = mainNavigation.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first === cart)
    }

    func test_showChat_showsChat() {
        subject.showInitialViewController()
        subject.showChat()

        guard let navigation = mainNavigation.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first === chat)
    }

    func test_dismissModal_dismissed() {
        subject.showInitialViewController()
        subject.dismissModal()

        XCTAssertTrue(mainNavigation.dismissed)
    }

    func test_showHome_poppedToRoot() {
        subject.showInitialViewController()
        subject.showHome()

        XCTAssertTrue(mainNavigation.poppedToRoot)
    }
}
