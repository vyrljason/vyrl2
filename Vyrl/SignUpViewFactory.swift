//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SignUpViewMaking {
    static func make(_ navigation: AuthorizationNavigating) -> SignUpViewController
}

enum SignUpViewFactory: SignUpViewMaking {
    static func make(_ navigation: AuthorizationNavigating) -> SignUpViewController {
        let interactor = SignUpInteractor()
        let viewController = SignUpViewController(interactor: interactor, formFactory: SignUpFormFactory.self)
        interactor.presenter = viewController
        interactor.signUpNavigation = navigation
        return viewController
    }
}
