//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import SlideMenuControllerSwift
@testable import Vyrl

final class RootNavigationInteractorTests: XCTestCase {

    var rootNavigationControllingMock: RootNavigationControllingMock!
    var subject: RootNavigationInteractor!

    override func setUp() {
        super.setUp()

        rootNavigationControllingMock = RootNavigationControllingMock()
        subject = RootNavigationInteractor()
        subject.delegate = rootNavigationControllingMock
    }

    func testCalledShowChat() {
        subject.didTapChat()

        XCTAssertTrue(rootNavigationControllingMock.showChatCalled)
    }

    func testCalledShowCart() {
        subject.didTapCart()

        XCTAssertTrue(rootNavigationControllingMock.showCartCalled)
    }

    func testCalledShowMenu() {
        subject.didTapMenu()

        XCTAssertTrue(rootNavigationControllingMock.showMenuCalled)
    }

    func testCalledDismiss() {
        subject.didTapClose()

        XCTAssertTrue(rootNavigationControllingMock.dismissModalCalled)
    }
}
