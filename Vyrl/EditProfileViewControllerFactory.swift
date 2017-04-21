//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol EditProfileViewControllerMaking {
    static func make(userProfile: UserProfile, accountReturner: AccountReturning) -> EditProfileViewController
}

enum EditProfileViewControllerFactory: EditProfileViewControllerMaking {
    static func make(userProfile: UserProfile, accountReturner: AccountReturning) -> EditProfileViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let industriesResource = Service<IndustriesResource>(resource: IndustriesResource(controller: resourceController))
        let industriesService = IndustriesService(resource: industriesResource)
        let updateUserIndustriesResource = PostService<UpdateUserIndustriesResource>(resource: UpdateUserIndustriesResource(controller: resourceController))
        let updateUserIndustriesService = UpdateUserIndustriesService(resource: updateUserIndustriesResource)
        let updateUserProfileResource = PostService<UpdateUserProfileResource>(resource: UpdateUserProfileResource(controller: resourceController))
        let updateUserProfileService = UpdateUserProfileService(resource: updateUserProfileResource)
        let userImageUploadResource = UploadUserImageResource(controller: resourceController)
        let userImageSignRequestUploadResource = UploadUserImageSignedRequestResource(controller: resourceController)
        let userImageUploadService = PostService<UploadUserImageResource>(resource: userImageUploadResource)
        let userImageSignedRequestService = UploadService<UploadUserImageSignedRequestResource>(resource: userImageSignRequestUploadResource)
        let userProfileUpdater = UserProfileUpdater(updateUserIndustriesService: updateUserIndustriesService,
                                                    updateUserProfileService: updateUserProfileService,
                                                    userImageUploadService: userImageUploadService,
                                                    userImageUploadSignedRequest: userImageSignedRequestService)
        let interactor = EditProfileInteractor(userProfile: userProfile, industriesService: industriesService,
                                               userProfileUpdater: userProfileUpdater, picker: PickerPresenter())
        interactor.accountReturner = accountReturner
        let editProfile = EditProfileViewController(interactor: interactor)
        return editProfile
    }
}
