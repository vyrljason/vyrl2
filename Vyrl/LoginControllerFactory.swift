//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol LoginControllerMaking {
    static func make(using listener: AuthorizationListener) -> LoginViewController
}

enum LoginControllerFactory: LoginControllerMaking {
    static func make(using listener: AuthorizationListener) -> LoginViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = UserLoginResource(controller: resourceController)
        let service = LoginService(resource: resource)
        let credentialsStorage = CredentialsStorage()
        let interactor = LoginInteractor(service: service, credentialsStorage: credentialsStorage)
        let controller = LoginViewController(interactor: interactor, formMaker: LoginFormFactory.self)
        interactor.presenter = controller
        interactor.listener = listener
        return controller
    }
}
