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
    func didFinishRegistration(_ newProfile: UserProfile)
}

protocol LoginPresenting: class {
    func presentLogin()
}

protocol SignUpPresenting: class {
    func presentSignUp()
}

final class AuthorizationNavigation: AuthorizationNavigating, NavigationControlling {
    let navigationController = UINavigationController()

    weak var listener: AuthorizationListener?
    fileprivate let webViewFactory: WebViewControllerMaking.Type
    fileprivate let editProfileFactory: EditProfileViewControllerFactory.Type
    
    init(listener: AuthorizationListener, welcomeViewFactory: WelcomeViewMaking.Type, webViewFactory: WebViewControllerMaking.Type, editProfileFactory: EditProfileViewControllerFactory.Type) {
        self.listener = listener
        self.webViewFactory = webViewFactory
        self.editProfileFactory = editProfileFactory
        
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

extension AuthorizationNavigation: SignUpPresenting {
    func presentSignUp() {
        let viewController = SignUpViewFactory.make(using: self)
        viewController.render(NavigationItemRenderable(titleImage: StyleKit.navigationBarLogo))
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishRegistration(_ newProfile: UserProfile) {
        self.presentEditProfile(with: newProfile, animated: true)
    }
}

extension AuthorizationNavigation: WebviewPresenting {
    func presentWebview(with url: URL, animated: Bool) {
        let viewController = webViewFactory.make(webViewContentUrl: url)
        navigationController.pushViewController(viewController, animated: animated)
    }
}

extension AuthorizationNavigation: EditProfilePresenting {
    func presentEditProfile(with userProfile: UserProfile?, animated: Bool) {
        let viewController = editProfileFactory.make(userProfile: userProfile, accountReturner: self)
        viewController.render(NavigationItemRenderable(titleImage: StyleKit.navigationBarLogo))
        navigationController.hideBackButton()
        navigationController.pushViewController(viewController, animated: animated)
    }
}

extension AuthorizationNavigation: AccountReturning {
    func returnToAccount(animated: Bool) {
        // brick wall or in, based solely on email?
        print("return to account")
        self.didFinishAuthorization()
    }
}

