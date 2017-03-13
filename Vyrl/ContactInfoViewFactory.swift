//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ContactInfoViewMaking {
    static func make(controller: ContactInfoControlling, listener: ContactInfoUpdateListening) -> ContactInfoViewController
}

enum ContactInfoViewFactory: ContactInfoViewMaking {
    static func make(controller: ContactInfoControlling, listener: ContactInfoUpdateListening) -> ContactInfoViewController {
        let interactor = ContactInfoInteractor()
        let viewController = ContactInfoViewController(interactor: interactor, formFactory: ContactInfoFormFactory.self)
        interactor.controller = controller
        interactor.presenter = viewController
        interactor.listener = listener
        return viewController
    }
}
