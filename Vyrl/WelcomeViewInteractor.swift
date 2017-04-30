//
//  WelcomeViewInteractor.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/1/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol WelcomeViewInteracting: class {
    // leave this in just in case we want to be able to display error alerts in welcome screen
    weak var presenter: ErrorAlertPresenting? { get set }
    weak var navigator: AuthorizationNavigating? { get set }
    func didTapLogin()
    func didTapSignUp()
}

final class WelcomeViewInteractor: WelcomeViewInteracting {
  
    weak var presenter: ErrorAlertPresenting?
    weak var navigator: AuthorizationNavigating?
    
    init(using navigator: AuthorizationNavigating) {
        self.navigator = navigator
    }
    
    func didTapLogin() {
        // present login VC
        guard let loginPresenter = navigator as? LoginPresenting else {
            assertionFailure("need a valid presenting navigator for login presentation")
            return
        }
        loginPresenter.presentLogin()
    }
    
    func didTapSignUp() {
        // present sign up VC
        guard let signUpPresenter = navigator as? SignUpPresenting else {
            assertionFailure("need a valid presenting navigator for signup presentation")
            return
        }
        signUpPresenter.presentSignUp()
    }
}
