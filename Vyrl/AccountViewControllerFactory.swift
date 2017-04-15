//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AccountViewControllerMaking {
    static func make(webviewPresenter: WebviewPresenting, sharePresenter: SharePresenting,
                     alertPresenter: AlertPresenting, settingsDismisser: SettingsDismissing) -> AccountViewController
}

enum AccountViewControllerFactory: AccountViewControllerMaking {
    static func make(webviewPresenter: WebviewPresenting, sharePresenter: SharePresenting,
                     alertPresenter: AlertPresenting, settingsDismisser: SettingsDismissing) -> AccountViewController {
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let userProfileResource = Service<UserProfileResource>(resource: UserProfileResource(controller: resourceController))
        let userProfileService = UserProfileService(resource: userProfileResource)
        let updateUserSettingsResource = PostService<UpdateUserSettingsResource>(resource: UpdateUserSettingsResource(controller: resourceController))
        let updateUserSettingsService = UpdateUserSettingsService(resource: updateUserSettingsResource)
        let deleteUserResource = Service<DeleteUserResource>(resource: DeleteUserResource(controller: resourceController))
        let deleteUserService = DeleteUserService(resource: deleteUserResource)
        let appVersionService = AppVersionService()
        let apiConfiguration = ServiceLocator.resourceConfigurator.configuration
        let credentialsStorage = CredentialsStorage()
        let credentialsProvider = APICredentialsProvider(storage: credentialsStorage)
        let chatCredentialsStorage = ChatCredentialsStorage()
        let unreadMessagesObserver = ServiceLocator.unreadMessagesObserver
        let interactor = AccountInteractor(userProfileService: userProfileService, appVersionService: appVersionService,
                                           apiConfiguration: apiConfiguration, updateUserSettingsService: updateUserSettingsService,
                                           deleteUserService: deleteUserService, credentialsProvider: credentialsProvider,
                                           chatCredentialsStorage: chatCredentialsStorage, unreadMessagesObserver: unreadMessagesObserver)
        interactor.webviewPresenter = webviewPresenter
        interactor.sharePresenter = sharePresenter
        interactor.alertPresenter = alertPresenter
        interactor.settingsDismisser = settingsDismisser
        let account = AccountViewController(interactor: interactor)
        return account
    }
}
