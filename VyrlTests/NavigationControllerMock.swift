//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class NavigationControllerMock: UINavigationController {

    var expectation: XCTestExpectation?
    var presented: UIViewController?
    var popped = false
    var poppedToRoot = false
    var dismissed = false
    var pushed: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        expectation?.fulfill()
        presented = viewControllerToPresent
        let _ = viewControllerToPresent.view
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        popped = true
        return nil
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        poppedToRoot = true
        return nil
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissed = true
        completion?()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushed = viewController
    }
}
