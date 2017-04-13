//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AccountViewControllerMaking {
    static func make() -> AccountViewController
}

enum AccountViewControllerFactory: AccountViewControllerMaking {
    static func make() -> AccountViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let resource = Service<UserProfileResource>(resource: UserProfileResource(controller: resourceController))
        let userProfileService = UserProfileService(resource: resource)
        let appVersionService = AppVersionService()
        let interactor = AccountInteractor(userProfileService: userProfileService, appVersionService: appVersionService)
        let account = AccountViewController(interactor: interactor)
        return account
    }
}
