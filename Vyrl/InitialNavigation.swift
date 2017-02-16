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

    private enum Constant {
        static let menuWidthRatio: CGFloat = 0.8
    }

    private let window: WindowProtocol
    private var slideMenu: SlideMenuController!
    private let mainView: ViewController
    private let leftMenu: LeftMenuViewController

    init(mainView: ViewController, leftMenu: LeftMenuViewController, window: WindowProtocol = UIWindow()) {
        self.mainView = mainView
        self.leftMenu = leftMenu
        self.window = window
    }

    func showInitialViewController() {
        setUpSlideMenu()
        presentSlideMenu()
    }

    private func presentSlideMenu() {
        slideMenu = SlideMenuController(mainViewController: mainView,
                                        leftMenuViewController: leftMenu)
        window.rootViewController = slideMenu
        makeWindowKeyAndVisible()
    }

    private func setUpSlideMenu() {
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.size.width * Constant.menuWidthRatio
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.contentViewDrag = true
    }

    private func makeWindowKeyAndVisible() {
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
    }
}
