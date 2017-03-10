//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class KeyboardHandlerTest: XCTestCase {
    var scrollView: UIScrollView!
    var subject: KeyboardHandler!

    override func setUp() {
        scrollView = UIScrollView()
        subject = KeyboardHandler(scrollView: scrollView)
        subject.animateOnStart = false
    }

    func test_keyboardWillHide_resetsInitialOffset_andInsets() {
        let expectedContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0)
        scrollView.contentInset = expectedContentInset

        subject.keyboardWillShow(notification: Notification(name: Notification.Name.UIKeyboardWillShow))
        subject.keyboardWillHide(notification: Notification(name: Notification.Name.UIKeyboardWillHide))

        XCTAssertEqual(scrollView.contentInset, expectedContentInset)
    }
}
