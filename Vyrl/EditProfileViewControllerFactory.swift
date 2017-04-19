//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol EditProfileViewControllerMaking {
    static func make(userProfile: UserProfile) -> EditProfileViewController
}

enum EditProfileViewControllerFactory: EditProfileViewControllerMaking {
    static func make(userProfile: UserProfile) -> EditProfileViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let industriesResource = Service<IndustriesResource>(resource: IndustriesResource(controller: resourceController))
        let industriesService = IndustriesService(resource: industriesResource)
        let interactor = EditProfileInteractor(userProfile: userProfile, industriesService: industriesService)
        let editProfile = EditProfileViewController(interactor: interactor)
        return editProfile
    }
}
