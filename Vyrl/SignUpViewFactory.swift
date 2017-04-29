//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SignUpViewMaking {
    static func make(using navigation: AuthorizationNavigating) -> SignUpViewController
}

enum SignUpViewFactory: SignUpViewMaking {
    static func make(using navigation: AuthorizationNavigating) -> SignUpViewController {
        let apiConfiguration = ServiceLocator.resourceConfigurator.configuration
        let interactor = SignUpInteractor(apiConfiguration: apiConfiguration)
        let viewController = SignUpViewController(interactor: interactor, formFactory: SignUpFormFactory.self)
        interactor.errorPresenter = viewController
        if let webPresentingNavigation = navigation as? WebviewPresenting {
            interactor.webviewPresenter = webPresentingNavigation
        }
        interactor.signUpNavigation = navigation
        return viewController
    }
}
