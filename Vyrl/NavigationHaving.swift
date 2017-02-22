//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol NavigationControlling: NavigationHaving, ModalNavigationControlling, StackNavigationControlling { }

protocol NavigationHaving {
    var navigationController: UINavigationController { get }
}

protocol ModalNavigationControlling {
    func dismiss(animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool)
}

protocol StackNavigationControlling {
    func goToFirst(animated: Bool)
}

extension NavigationHaving where Self: StackNavigationControlling {
    func goToFirst(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }
}

extension NavigationHaving where Self: StackNavigationControlling {
    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated, completion: nil)
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        navigationController.present(viewController, animated: animated, completion: nil)
    }
}
