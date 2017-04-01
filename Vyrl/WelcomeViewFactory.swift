//
//  WelcomeViewFactory.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/1/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol WelcomeViewMaking {
    static func make() -> WelcomeViewController
}

enum WelcomeViewFactory: WelcomeViewMaking {
    static func make() -> WelcomeViewController {
        let interactor = WelcomeViewInteractor()
        let viewController = WelcomeViewController(interactor: interactor)
        interactor.presenter = viewController
        return viewController
    }
}
