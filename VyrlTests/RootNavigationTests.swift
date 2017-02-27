//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import SlideMenuControllerSwift
@testable import Vyrl

final class RootNavigationTests: XCTestCase {
    private var subject: RootNavigation!
    private var window: WindowMock!
    private var navigationProvider: NavigationProviderMock!
    private var brandsNavigationController: NavigationControllerMock!
    private var mainView: UIViewController!
    private var cart: UIViewController!
    private var chat: UIViewController!
    private var leftMenu: LeftMenuViewController!
    private var interactor: RootNavigationInteractor!
    private var dataSource: DataSourceMock!

    override func setUp() {
        super.setUp()
        window = WindowMock()
        chat = UIViewController()
        cart = UIViewController()
        dataSource = DataSourceMock()
        leftMenu = LeftMenuViewController(interactor: LeftMenuInteractor(dataSource: dataSource))
        interactor = RootNavigationInteractor()
        brandsNavigationController = NavigationControllerMock()
        navigationProvider = NavigationProviderMock(navigationController: brandsNavigationController)

        let builder = RootNavigationBuilder()
        builder.interactor = interactor
        builder.leftMenu = leftMenu
        builder.cart = cart
        builder.chat = chat
        builder.window = window
        builder.mainNavigation = navigationProvider

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

    func test_showAccount_slideMenuHasCorrectViewControllers() {
        subject.showInitialViewController()
        subject.showAccount()

        guard let navigation = brandsNavigationController.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first! is AccountViewController)
    }

    func test_showCart_showsCart() {
        subject.showInitialViewController()
        subject.showCart()

        guard let navigation = brandsNavigationController.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first === cart)
    }

    func test_showChat_showsChat() {
        subject.showInitialViewController()
        subject.showChat()

        guard let navigation = brandsNavigationController.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first === chat)
    }

    func test_dismissModal_dismissed() {
        subject.showInitialViewController()
        subject.dismissModal()

        XCTAssertTrue(navigationProvider.didDismissModal)
    }

    func test_showHome_poppedToRoot() {
        subject.showInitialViewController()
        subject.showHome()

        XCTAssertTrue(navigationProvider.didResetNavigation)
    }
}
