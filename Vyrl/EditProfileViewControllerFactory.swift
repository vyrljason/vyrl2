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
        let updateUserIndustriesResource = PostService<UpdateUserIndustriesResource>(resource: UpdateUserIndustriesResource(controller: resourceController))
        let updateUserIndustriesService = UpdateUserIndustriesService(resource: updateUserIndustriesResource)
        let updateUserProfileResource = PostService<UpdateUserProfileResource>(resource: UpdateUserProfileResource(controller: resourceController))
        let updateUserProfileService = UpdateUserProfileService(resource: updateUserProfileResource)
        let imageUploader = ImageUploadResource(controller: resourceController)
        let imageToDataConverter = ImageToDataConverter()
        let userProfileUpdater = UserProfileUpdater(updateUserIndustriesService: updateUserIndustriesService, updateUserProfileService: updateUserProfileService, imageUploader: imageUploader, imageConverter: imageToDataConverter)
        let interactor = EditProfileInteractor(userProfile: userProfile, industriesService: industriesService, userProfileUpdater: userProfileUpdater)
        let editProfile = EditProfileViewController(interactor: interactor)
        return editProfile
    }
}
