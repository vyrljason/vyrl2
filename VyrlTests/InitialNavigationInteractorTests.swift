//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import SlideMenuControllerSwift
@testable import Vyrl

final class InitialNavigationInteractorTests: XCTestCase {

    var initialNavigationControllingMock: InitialNavigationControllingMock!
    var subject: InitialNavigationInteractor!

    override func setUp() {
        super.setUp()

        initialNavigationControllingMock = InitialNavigationControllingMock()
        subject = InitialNavigationInteractor()
        subject.delegate = initialNavigationControllingMock
    }

    func testCalledShowChat() {
        subject.didTapChat()

        XCTAssertTrue(initialNavigationControllingMock.showChatCalled)
    }

    func testCalledShowCart() {
        subject.didTapCart()

        XCTAssertTrue(initialNavigationControllingMock.showCartCalled)
    }

    func testCalledShowMenu() {
        subject.didTapMenu()

        XCTAssertTrue(initialNavigationControllingMock.showMenuCalled)
    }

    func testCalledDismiss() {
        subject.didTapClose()

        XCTAssertTrue(initialNavigationControllingMock.dismissModalCalled)
    }
}
