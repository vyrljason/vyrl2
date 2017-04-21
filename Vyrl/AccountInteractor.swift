//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static let failedToFetchUserProfile: String = NSLocalizedString("account.error.failedToFetchUserProfile", comment: "")
    static let failedToUpdateUserSettings: String = NSLocalizedString("account.error.failedToUpdateUserSettings", comment: "")
    static let failedToDeleteUser: String = NSLocalizedString("account.error.failedToDeleteUser", comment: "")
    static let shareText: String = NSLocalizedString("account.share.text", comment: "")
    static let deleteAlertTitle: String = NSLocalizedString("account.deleteAlert.title", comment: "")
    static let deleteAlertMessage: String = NSLocalizedString("account.deleteAlert.message", comment: "")
}

protocol AccountInteracting {
    weak var controller: AccountControlling? { get set }
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    weak var webviewPresenter: WebviewPresenting? { get set }
    weak var sharePresenter: SharePresenting? { get set }
    weak var profilePresenter: ProfilePresenting? { get set }
    func didTapViewProfile()
    func didTapTermsOfService()
    func didTapFaq()
    func didTapFoundABug()
    func didTapDeleteAccount()
    func didSwitchEmailNotifications(value: Bool)
    func didSwitchPushNotifications(value: Bool)
    func viewWillAppear()
}

@objc protocol ApplicationSharing {
    func didTapShare()
}

final class AccountInteractor: AccountInteracting {
    
    fileprivate let userProfileService: UserProfileProviding
    fileprivate let appVersionService: AppVersionProviding
    fileprivate let updateUserSettingsService: UserSettingsUpdating
    fileprivate let deleteUserService: UserDeleting
    fileprivate let apiConfiguration: APIConfigurationHaving
    fileprivate let credentialsProvider: APICredentialsProviding
    fileprivate let chatCredentialsStorage: ChatCredentialsStoring
    fileprivate let unreadMessagesObserver: UnreadMessagesObserving
    fileprivate var userProfile: UserProfile?
    weak var controller: AccountControlling?
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter?
    weak var errorPresenter: ErrorAlertPresenting?
    weak var webviewPresenter: WebviewPresenting?
    weak var sharePresenter: SharePresenting?
    weak var alertPresenter: AlertPresenting?
    weak var authorizationPresenter: AuthorizationScreenPresenting?
    weak var settingsDismisser: SettingsDismissing?
    weak var profilePresenter: ProfilePresenting?
    
    // swiftlint:disable function_parameter_count
    init(userProfileService: UserProfileProviding, appVersionService: AppVersionProviding,
         apiConfiguration: APIConfigurationHaving, updateUserSettingsService: UserSettingsUpdating,
         deleteUserService: UserDeleting, credentialsProvider: APICredentialsProviding,
         chatCredentialsStorage: ChatCredentialsStoring, unreadMessagesObserver: UnreadMessagesObserving) {
        self.userProfileService = userProfileService
        self.appVersionService = appVersionService
        self.apiConfiguration = apiConfiguration
        self.updateUserSettingsService = updateUserSettingsService
        self.deleteUserService = deleteUserService
        self.credentialsProvider = credentialsProvider
        self.chatCredentialsStorage = chatCredentialsStorage
        self.unreadMessagesObserver = unreadMessagesObserver
    }
    
    func viewWillAppear() {
        fetchUserProfile()
        setAppVersion()
    }
    
    func didTapFaq() {
        webviewPresenter?.presentWebview(with: apiConfiguration.faqURL, animated: true)
    }
    
    func didTapTermsOfService() {
        webviewPresenter?.presentWebview(with: apiConfiguration.tosURL, animated: true)
    }
    
    func didTapFoundABug() {
        webviewPresenter?.presentWebview(with: apiConfiguration.bugReportURL, animated: true)
    }
    
    func didTapViewProfile() {
        guard let userProfile = self.userProfile else { return }
        profilePresenter?.presentProfile(with: userProfile, animated: true)
    }
    
    func didTapDeleteAccount() {
        deleteUser()
    }
    
    func didSwitchPushNotifications(value: Bool) {
        guard let userProfile = self.userProfile else { return }
        let userSettings = UserSettings(chatRequestsEnabled: userProfile.settings.chatRequestsEnabled,
                                        emailNotificationsEnabled: userProfile.settings.emailNotificationsEnabled,
                                        pushNotificationsEnabled: value)
        updateUserSettings(userSettings: userSettings)
    }
    
    func didSwitchEmailNotifications(value: Bool) {
        guard let userProfile = self.userProfile else { return }
        let userSettings = UserSettings(chatRequestsEnabled: userProfile.settings.chatRequestsEnabled,
                                        emailNotificationsEnabled: value,
                                        pushNotificationsEnabled: userProfile.settings.pushNotificationsEnabled)
        updateUserSettings(userSettings: userSettings)
    }
    
    fileprivate func fetchUserProfile() {
        activityIndicatorPresenter?.presentActivity()
        userProfileService.get { [weak self] result in
            guard let `self` = self else { return }
            self.activityIndicatorPresenter?.dismissActivity()
            result.on(success: { userProfile in
                self.userProfile = userProfile
                self.setView(using: userProfile)
            }, failure: { _ in
                self.errorPresenter?.presentError(title: nil, message: Constants.failedToFetchUserProfile)
            })
        }
    }
    
    fileprivate func updateUserSettings(userSettings: UserSettings) {
        activityIndicatorPresenter?.presentActivity()
        updateUserSettingsService.update(userSettings: userSettings) { [weak self] result in
            guard let `self` = self else { return }
            self.activityIndicatorPresenter?.dismissActivity()
            result.on(success: nil, failure: { _ in
                self.errorPresenter?.presentError(title: nil, message: Constants.failedToUpdateUserSettings)
                guard let userProfile = self.userProfile else { return }
                self.controller?.setEmailStatus(emailStatus: userProfile.settings.emailNotificationsEnabled)
                self.controller?.setPushStatus(pushStatus: userProfile.settings.pushNotificationsEnabled)
            })
        }
    }
    
    fileprivate func setAppVersion() {
        let version = "version \(appVersionService.appVersion()) (\(appVersionService.buildVersion()))"
        controller?.setVersionLabel(text: version)
    }
    
    fileprivate func setView(using userProfile: UserProfile) {
        self.controller?.setEmailStatus(emailStatus: userProfile.settings.emailNotificationsEnabled)
        self.controller?.setPushStatus(pushStatus: userProfile.settings.pushNotificationsEnabled)
        self.controller?.setInfluencerLabel(text: userProfile.username)
        guard let avatarUrl = userProfile.avatar else { return }
        self.controller?.setAvatar(imageFetcher: ImageFetcher(url: avatarUrl))
    }
    
    fileprivate func deleteUser() {
        alertPresenter?.presentAlert(with: Constants.deleteAlertTitle, message: Constants.deleteAlertMessage,
                                     onAccept: { [weak self] _ in
            guard let `self` = self else { return }
            self.settingsDismisser?.dismiss()
            self.activityIndicatorPresenter?.presentActivity()
            self.deleteUserService.delete(completion: { result in
                result.on(success: { _ in
                    self.activityIndicatorPresenter?.dismissActivity()
                    self.credentialsProvider.clear()
                    self.chatCredentialsStorage.clear()
                    self.unreadMessagesObserver.stopObserving()
                    self.settingsDismisser?.dismiss()
                }, failure: { _ in
                    self.errorPresenter?.presentError(title: nil, message: Constants.failedToDeleteUser)
                })
            })
        })
    }
}

extension AccountInteractor: ApplicationSharing {
    func didTapShare() {
        sharePresenter?.presentShare(with: Constants.shareText, url: apiConfiguration.shareURL, animated: true)
    }
}
