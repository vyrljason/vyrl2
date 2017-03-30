//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol SignUpViewMaking {
    static func make() -> SignUpViewController
}

enum SignUpViewFactory: SignUpViewMaking {
    static func make() -> SignUpViewController {
        let interactor = SignUpInteractor()
        let viewController = SignUpViewController(interactor: interactor, formFactory: SignUpFormFactory.self)
        interactor.presenter = viewController
        return viewController
    }
}
