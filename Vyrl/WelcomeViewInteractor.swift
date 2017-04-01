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
    func didTapLogin()
    func didTapSignUp()
}

final class WelcomeViewInteractor: WelcomeViewInteracting {
    
    weak var presenter: ErrorAlertPresenting?

    func didTapLogin() {
        // present login VC
    }
    
    func didTapSignUp() {
        // present sign up VC
    }
}
