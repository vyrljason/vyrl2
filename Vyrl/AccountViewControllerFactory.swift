//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AccountViewControllerMaking {
    static func make(webviewPresenter: WebviewPresenting, sharePresenter: SharePresenting) -> AccountViewController
}

enum AccountViewControllerFactory: AccountViewControllerMaking {
    static func make(webviewPresenter: WebviewPresenting, sharePresenter: SharePresenting) -> AccountViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = Service<UserProfileResource>(resource: UserProfileResource(controller: resourceController))
        let userProfileService = UserProfileService(resource: resource)
        let appVersionService = AppVersionService()
        let apiConfiguration = ServiceLocator.resourceConfigurator.configuration
        let interactor = AccountInteractor(userProfileService: userProfileService, appVersionService: appVersionService,
                                           apiConfiguration: apiConfiguration)
        interactor.webviewPresenter = webviewPresenter
        interactor.sharePresenter = sharePresenter
        let account = AccountViewController(interactor: interactor)
        return account
    }
}
