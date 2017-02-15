//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class WindowMock: UIWindow {
    var didCalledMakeKeyAndVisible = false
    var setRootViewController: UIViewController?
    var givenRootViewController: UIViewController?

    override func makeKeyAndVisible() {
        didCalledMakeKeyAndVisible = true
    }

    override var rootViewController: UIViewController? {
        get {
            return givenRootViewController
        }
        set {
            setRootViewController = newValue
        }
    }
}
