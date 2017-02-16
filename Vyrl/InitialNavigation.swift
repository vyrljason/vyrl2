//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

protocol WindowProtocol: class {
    func makeKeyAndVisible()
    var isKeyWindow: Bool { get }
    var rootViewController: UIViewController? { get set }
}

extension UIWindow: WindowProtocol { }

final class InitialNavigation {

    private let window: WindowProtocol
    private var initialViewController: SlideMenuController!

    init(window: WindowProtocol = UIWindow()) {
        self.window = window
    }

    func showInitialViewController() {
        presentViewController()
    }

    private func presentViewController() {
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.size.width * 0.8
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.contentViewDrag = true
        let main = ViewController()
        let leftMenu = LeftMenuViewController()
        initialViewController = SlideMenuController(mainViewController: main,
                                                    leftMenuViewController: leftMenu)
        window.rootViewController = initialViewController
        makeWindowKeyAndVisible()
    }

    private func makeWindowKeyAndVisible() {
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
    }
}
