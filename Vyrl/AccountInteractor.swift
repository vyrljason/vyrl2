//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static let failedToFetchUserProfile: String = NSLocalizedString("account.error.failedToFetchUserProfile", comment: "")
}

protocol AccountInteracting {
    weak var viewController: AccountControlling? { get set }
    weak var activityLoaderPresenter: ActivityLoaderPresenting? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
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
    fileprivate var userProfile: UserProfile?
    weak var viewController: AccountControlling?
    weak var activityLoaderPresenter: ActivityLoaderPresenting?
    weak var errorPresenter: ErrorAlertPresenting?
    
    init(userProfileService: UserProfileProviding, appVersionService: AppVersionProviding) {
        self.userProfileService = userProfileService
        self.appVersionService = appVersionService
    }
    
    func viewWillAppear() {
        fetchUserProfile()
        setAppVersion()
    }
    
    func didTapFaq() {
        
    }
    
    func didTapFoundABug() {
        
    }
    
    func didTapViewProfile() {
        
    }
    
    func didTapDeleteAccount() {
        
    }
    
    func didTapTermsOfService() {
        
    }
    
    func didSwitchPushNotifications(value: Bool) {
        
    }
    
    func didSwitchEmailNotifications(value: Bool) {
        
    }
    
    fileprivate func fetchUserProfile() {
        activityLoaderPresenter?.showActivityLoader()
        userProfileService.get { [weak self] result in
            guard let `self` = self else { return }
            self.activityLoaderPresenter?.hideActivityLoader()
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
        viewController?.setVersionLabel(text: version)
    }
    
    fileprivate func setView(using userProfile: UserProfile) {
        self.viewController?.setEmailStatus(emailStatus: userProfile.settings.emailNotificationsEnabled)
        self.viewController?.setPushStatus(pushStatus: userProfile.settings.pushNotificationsEnabled)
        self.viewController?.setInfluencerLabel(text: userProfile.username)
        guard let avatarUrl = userProfile.avatar else { return }
        self.viewController?.setAvatar(imageFetcher: ImageFetcher(url: avatarUrl))
    }
}

extension AccountInteractor: ApplicationSharing {
    func didTapShare() {
        
    }
}
