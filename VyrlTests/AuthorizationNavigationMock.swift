//
//  AuthorizationNavigationMock.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/2/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class AuthorizationNavigationMock: AuthorizationNavigating, NavigationControlling {
    
    weak var listener: AuthorizationListener?
    var navigationController: UINavigationController = UINavigationController()

    var finishAuthCalled: Bool = false
    var finishRegistrationCalled: Bool = false
    
    func didFinishAuthorization() {
        finishAuthCalled = true
    }
    
    func didFinishRegistration(_ newProfile: UserProfile) {
        finishRegistrationCalled = true
    }



}
