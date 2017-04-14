//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static let failedToFetchUserProfile: String = NSLocalizedString("account.error.failedToFetchUserProfile", comment: "")
    static let shareText: String = NSLocalizedString("account.share.text", comment: "")
}

protocol AccountInteracting {
    weak var controller: AccountControlling? { get set }
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    weak var webviewPresenter: WebviewPresenting? { get set }
    weak var sharePresenter: SharePresenting? { get set }
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
    fileprivate let apiConfiguration: APIConfigurationHaving
    fileprivate var userProfile: UserProfile?
    weak var controller: AccountControlling?
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter?
    weak var errorPresenter: ErrorAlertPresenting?
    weak var webviewPresenter: WebviewPresenting?
    weak var sharePresenter: SharePresenting?
    
    init(userProfileService: UserProfileProviding, appVersionService: AppVersionProviding,
         apiConfiguration: APIConfigurationHaving) {
        self.userProfileService = userProfileService
        self.appVersionService = appVersionService
        self.apiConfiguration = apiConfiguration
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
        
    }
    
    func didTapDeleteAccount() {
        
    }
    
    func didSwitchPushNotifications(value: Bool) {
        
    }
    
    func didSwitchEmailNotifications(value: Bool) {
        
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
}

extension AccountInteractor: ApplicationSharing {
    func didTapShare() {
        sharePresenter?.presentShare(with: Constants.shareText, url: apiConfiguration.shareURL, animated: true)
    }
}
