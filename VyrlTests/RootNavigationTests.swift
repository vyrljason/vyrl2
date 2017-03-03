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
    private var navigationController: NavigationControllerMock!
    private var mainView: UIViewController!
    private var cart: CartNavigating!
    private var chat: UIViewController!
    private var leftMenu: LeftMenuViewController!
    private var interactor: RootNavigationInteractor!
    private var dataSource: DataSourceMock!
    private var credentialsProvider: APICredentialsProviderMock!
    private var leftMenuInteractor: LeftMenuInteractor!

    override func setUp() {
        super.setUp()
        window = WindowMock()
        chat = UIViewController()
        cart = CartNavigationBuilder().build()
        credentialsProvider = APICredentialsProviderMock()
        dataSource = DataSourceMock()
        leftMenuInteractor = LeftMenuInteractor(dataSource: dataSource, credentialsProvider: credentialsProvider)
        leftMenu = LeftMenuViewController(interactor: leftMenuInteractor)
        interactor = RootNavigationInteractor()
        navigationController = NavigationControllerMock()
        navigationProvider = NavigationProviderMock(navigationController: navigationController)

        let builder = RootNavigationBuilder()
        builder.interactor = interactor
        builder.leftMenu = leftMenu
        builder.cart = cart
        builder.chat = chat
        builder.window = window
        builder.mainNavigation = navigationProvider
        builder.credentialsProvider = credentialsProvider

        subject = builder.build()
    }

    func test_showInitialViewController_whenUserIsLoggedIn_showsSlideMenuController() {
        credentialsProvider.userAccessToken = "token"
        subject.showInitialViewController(animated: false)
        XCTAssertTrue(window.setRootViewController! is SlideMenuController)
    }

    func test_showInitialViewController_whenUserIsNotLoggedIn_showsLoginViewController() {
        credentialsProvider.userAccessToken = nil
        subject.showInitialViewController(animated: false)

        if let navigationController = window.setRootViewController as? UINavigationController {
            XCTAssertTrue(navigationController.topViewController is LoginViewController)
        } else {
            XCTFail()
        }
    }

    func test_showInitialViewController_whenUserIsLoggedIn_slideMenuHasCorrectViewControllers() {
        credentialsProvider.userAccessToken = "token"

        subject.showInitialViewController(animated: false)

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

        guard let navigation = navigationController.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first! is AccountViewController)
    }

    func test_showCart_showsCart() {
        subject.showInitialViewController()
        subject.showCart()

        guard let navigation = navigationController.presented as? UINavigationController else {
            XCTFail()
            return
        }

        XCTAssertTrue(navigation.viewControllers.first is CartViewController)
    }

    func test_showChat_showsChat() {
        subject.showInitialViewController()
        subject.showChat()

        guard let navigation = navigationController.presented as? UINavigationController else {
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
