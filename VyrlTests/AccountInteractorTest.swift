//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class UserProfileServiceMock: UserProfileProviding {
    var success = true
    var error = ServiceError.unknown
    var response = VyrlFaker.faker.userProfile()
    
    func get(completion: @escaping (Result<UserProfile, ServiceError>) -> Void) {
        if success {
            completion(.success(response))
        } else {
            completion(.failure(error))
        }
    }
}

final class AppVersionServiceMock: AppVersionProviding {
    var didCallAppVersion = false
    var didCallBuildVersion = false
    
    func appVersion() -> String {
        didCallAppVersion = true
        return ""
    }
    
    func buildVersion() -> String {
        didCallBuildVersion = true
        return ""
    }
}

final class UpdateUserSettingsServiceMock: UserSettingsUpdating {
    var success = true
    var error = ServiceError.unknown
    var response = EmptyResponse()
    
    func update(userSettings: UserSettings, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        if success {
            completion(.success(response))
        } else {
            completion(.failure(error))
        }
    }
}

final class DeleteUserServiceMock: UserDeleting {
    var success = true
    var error = ServiceError.unknown
    var response = EmptyResponse()
    
    func delete(completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        if success {
            completion(.success(response))
        } else {
            completion(.failure(error))
        }
    }
}

final class AccountControllerMock: AccountControlling {
    var didCallSetVersion = false
    var didCallSetPush = false
    var didCallSetEmail = false
    var didCallSetInfluencer = false
    var didCallSetAvatar = false
    
    func setVersionLabel(text: String) {
        didCallSetVersion = true
    }
    
    func setPushStatus(pushStatus: Bool) {
        didCallSetPush = true
    }
    
    func setInfluencerLabel(text: String) {
        didCallSetInfluencer = true
    }
    
    func setEmailStatus(emailStatus: Bool) {
        didCallSetEmail = true
    }
    
    func setAvatar(imageFetcher: ImageFetcher) {
        didCallSetAvatar = true
    }
}

final class WebviewPresenterMock: WebviewPresenting {
    var didCallPresentWebview = false
    
    func presentWebview(with url: URL, animated: Bool) {
        didCallPresentWebview = true
    }
}

final class SharePresenterMock: SharePresenting {
    var didCallPresentShare = false
    
    func presentShare(with text: String, url: URL, animated: Bool) {
        didCallPresentShare = true
    }
}

final class AlertPresenterMock: AlertPresenting {
    var didCallPresentAlert = false
    
    func presentAlert(with title: String?, message: String?, onAccept: ((UIAlertAction) -> Void)?) {
        didCallPresentAlert = true
    }
}

final class ProfilePresenterMock: ProfilePresenting {
    var didCallPresentProfile = false
    
    func presentProfile(with userProfile: UserProfile, animated: Bool) {
        didCallPresentProfile = true
    }
}

final class AuthorizationScreenPresentingMock: AuthorizationScreenPresenting {
    var didCallShowAuthorization = false
    
    func showAuthorization() {
        didCallShowAuthorization = true
    }
}

final class SettingsDismisserMock: SettingsDismissing {
    var didCallDismiss = false
    
    func dismiss() {
        didCallDismiss = true
    }
}

final class AccountInteractorTest: XCTestCase {
    
    var subject: AccountInteractor!
    var userProfileService: UserProfileServiceMock!
    var appVersionService: AppVersionServiceMock!
    var apiConfiguration: APIConfigurationMock!
    var updateUserSettingsService: UpdateUserSettingsServiceMock!
    var deleteUserService: DeleteUserServiceMock!
    var credentialsProvider: APICredentialsProviding!
    var chatCredentialsStorage: ChatCredentialsStorageMock!
    var unreadMessagesObserver: UnreadMessagesObserverMock!
    var controller: AccountControllerMock!
    var errorPresenter: ErrorPresenterMock!
    var webviewPresenter: WebviewPresenterMock!
    var sharePresenter: SharePresenterMock!
    var alertPresenter: AlertPresenterMock!
    var authorizationPresenter: AuthorizationScreenPresentingMock!
    var settingsDismisser: SettingsDismisserMock!
    var profilePresenter: ProfilePresenterMock!
    
    override func setUp() {
        userProfileService = UserProfileServiceMock()
        appVersionService = AppVersionServiceMock()
        apiConfiguration = APIConfigurationMock()
        updateUserSettingsService = UpdateUserSettingsServiceMock()
        deleteUserService = DeleteUserServiceMock()
        credentialsProvider = APICredentialsProviderMock()
        chatCredentialsStorage = ChatCredentialsStorageMock()
        unreadMessagesObserver = UnreadMessagesObserverMock()
        controller = AccountControllerMock()
        errorPresenter = ErrorPresenterMock()
        webviewPresenter = WebviewPresenterMock()
        sharePresenter = SharePresenterMock()
        alertPresenter = AlertPresenterMock()
        authorizationPresenter = AuthorizationScreenPresentingMock()
        settingsDismisser = SettingsDismisserMock()
        profilePresenter = ProfilePresenterMock()
        
        subject = AccountInteractor(userProfileService: userProfileService, appVersionService: appVersionService,
                                    apiConfiguration: apiConfiguration, updateUserSettingsService: updateUserSettingsService,
                                    deleteUserService: deleteUserService, credentialsProvider: credentialsProvider,
                                    chatCredentialsStorage: chatCredentialsStorage, unreadMessagesObserver: unreadMessagesObserver)
        subject.controller = controller
        subject.errorPresenter = errorPresenter
        subject.webviewPresenter = webviewPresenter
        subject.sharePresenter = sharePresenter
        subject.alertPresenter = alertPresenter
        subject.authorizationPresenter = authorizationPresenter
        subject.settingsDismisser = settingsDismisser
        subject.profilePresenter = profilePresenter
    }
    
    func test_onViewWillAppear_setVersionLabel() {
        subject.viewWillAppear()
        
        XCTAssertTrue(controller.didCallSetVersion)
    }
    
    func test_onViewWillAppear_setView() {
        subject.viewWillAppear()
        
        XCTAssertTrue(controller.didCallSetInfluencer)
        XCTAssertTrue(controller.didCallSetPush)
        XCTAssertTrue(controller.didCallSetAvatar)
        XCTAssertTrue(controller.didCallSetEmail)
    }
    
    func test_didTapShare_callPresenter() {
        subject.didTapShare()
        
        XCTAssertTrue(sharePresenter.didCallPresentShare)
    }
    
    func test_didTapFaq_callPresenter() {
        subject.didTapFaq()
        
        XCTAssertTrue(webviewPresenter.didCallPresentWebview)
    }
    
    func test_didTapTos_callPresenter() {
        subject.didTapTermsOfService()
        
        XCTAssertTrue(webviewPresenter.didCallPresentWebview)
    }
    
    func test_didTapFoundABug_callPresenter() {
        subject.didTapFoundABug()
        
        XCTAssertTrue(webviewPresenter.didCallPresentWebview)
    }
    
    func test_didTapViewProfile_callPresenter() {
        subject.viewWillAppear()
        subject.didTapViewProfile()
        
        XCTAssertTrue(profilePresenter.didCallPresentProfile)
    }
    
    func test_didTapViewProfile_notCallPresenter() {
        userProfileService.success = false
        subject.viewWillAppear()
        subject.didTapViewProfile()
        
        XCTAssertFalse(profilePresenter.didCallPresentProfile)
    }
}
