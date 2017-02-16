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

enum MainViewFactory {
    static func initialize() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        return viewController
    }
}

final class InitialNavigation {

    private enum Constant {
        static let menuWidthRatio: CGFloat = 0.8
        static let contentViewScale: CGFloat = 1.0
        static let titleImage: UIImage = UIImage()
    }

    private let window: WindowProtocol
    private var slideMenu: SlideMenuController!
    private let mainView: UIViewController
    private var mainNavigation: UINavigationController!
    private let leftMenu: UIViewController

    init(mainView: UIViewController, leftMenu: UIViewController, window: WindowProtocol = UIWindow()) {
        self.mainView = mainView
        self.leftMenu = leftMenu
        self.window = window
    }

    func showInitialViewController() {
        setUpSlideMenuOptions()
        presentSlideMenu()
    }

    private func presentSlideMenu() {
        setUpNavigationItems(in: mainView)
        setUpMainNavigationController()
        createAndPresentSlideMenu()
    }

    private func setUpNavigationItems(in viewController: UIViewController) {
        viewController.render(NavigationItemRenderable(titleImage: Constant.titleImage))
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "H",
                                                                          style: .plain,
                                                                          target: self,
                                                                          action: #selector(showLeftMenu))
    }

    private func createAndPresentSlideMenu() {
        slideMenu = SlideMenuController(mainViewController: mainNavigation,
                                        leftMenuViewController: leftMenu)
        window.rootViewController = slideMenu
        makeWindowKeyAndVisible()
    }

    private func setUpMainNavigationController() {
        mainNavigation = UINavigationController(rootViewController: mainView)
        let renderable = NavigationBarRenderable(tintColor: .white, backgroundColor: .rouge, translucent: false)
        mainNavigation.render(renderable)
    }

    private func setUpSlideMenuOptions() {
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.size.width * Constant.menuWidthRatio
        SlideMenuOptions.contentViewScale = Constant.contentViewScale
        SlideMenuOptions.contentViewDrag = true
    }

    private func makeWindowKeyAndVisible() {
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
    }

    @objc private func showLeftMenu() {
        slideMenu.openLeft()
    }
}
