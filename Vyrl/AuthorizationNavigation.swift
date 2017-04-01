//
//  SignUpNavigation.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/1/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AuthorizationNavigating: class {
    weak var authorizationNavigationController: UINavigationController? { get set }
    weak var listener: AuthorizationListener? { get set }

    func didFinishAuthorization()
}

final class AuthorizationNavigation: AuthorizationNavigating {
    weak var authorizationNavigationController: UINavigationController?
    weak var listener: AuthorizationListener?

    init(listener: AuthorizationListener, welcomeViewFactory: WelcomeViewMaking.Type) {
        self.listener = listener
        let welcomeViewController = welcomeViewFactory.make()
        self.authorizationNavigationController = UINavigationController(rootViewController: welcomeViewController)
    }
    
    func didFinishAuthorization() {
        listener?.didFinishAuthorizing()
    }
}
