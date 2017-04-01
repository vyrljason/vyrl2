//
//  SignUpNavigation.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/1/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AuthorizationNavigating: class {
    weak var listener: AuthorizationListener? { get set }

    func didFinishAuthorization()
}

protocol LoginPresenting: class {
    func presentLogin()
}

final class AuthorizationNavigation: AuthorizationNavigating, NavigationControlling {
    let navigationController = UINavigationController()

    weak var listener: AuthorizationListener?

    init(listener: AuthorizationListener, welcomeViewFactory: WelcomeViewMaking.Type) {
        self.listener = listener
        let welcomeViewController = welcomeViewFactory.make(using: self)
        self.navigationController.viewControllers = [welcomeViewController]
    }
    
    func didFinishAuthorization() {
        listener?.didFinishAuthorizing()
    }
}

extension AuthorizationNavigation: LoginPresenting {
    func presentLogin() {
        let viewController = LoginControllerFactory.make(using: self)
        viewController.render(NavigationItemRenderable(titleImage: StyleKit.navigationBarLogo))
        navigationController.pushViewController(viewController, animated: true)
    }
}
