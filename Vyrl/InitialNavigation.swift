//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol WindowProtocol: class {
    func makeKeyAndVisible()
    var isKeyWindow: Bool { get }
    var rootViewController: UIViewController? { get set }
}

extension UIWindow: WindowProtocol { }

final class InitialNavigation {

    private let window: WindowProtocol
    private var initialViewController: UIViewController!

    init(window: WindowProtocol = UIWindow()) {
        self.window = window
    }

    func showInitialViewController() {
        presentViewController()
    }

    private func presentViewController() {
        initialViewController = ViewController()
        window.rootViewController = initialViewController
        makeWindowKeyAndVisible()
    }

    private func makeWindowKeyAndVisible() {
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
    }
}
