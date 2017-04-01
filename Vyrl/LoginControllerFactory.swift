//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol LoginControllerMaking {
    static func make(using navigator: AuthorizationNavigating) -> LoginViewController
}

enum LoginControllerFactory: LoginControllerMaking {
    static func make(using navigator: AuthorizationNavigating) -> LoginViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = UserLoginResource(controller: resourceController)
        let service = LoginService(resource: resource)
        let credentialsStorage = CredentialsStorage()
        let interactor = LoginInteractor(service: service, credentialsStorage: credentialsStorage, navigator: navigator)
        let controller = LoginViewController(interactor: interactor, formMaker: LoginFormFactory.self)
        interactor.presenter = controller
        interactor.navigator = navigator
        return controller
    }
}
