//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let shareTitle: String = NSLocalizedString("account.share.title", comment: "")
}

protocol AccountControlling: class {
    func setAvatar(imageFetcher: ImageFetcher)
    func setInfluencerLabel(text: String)
    func setVersionLabel(text: String)
    func setEmailStatus(emailStatus: Bool)
    func setPushStatus(pushStatus: Bool)
}

protocol ActivityLoaderPresenting: class {
    func showActivityLoader()
    func hideActivityLoader()
}

final class AccountViewController: UIViewController, HavingNib {
    static var nibName: String = "AccountViewController"
    
    @IBOutlet fileprivate weak var avatarImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var influencerNameLabel: UILabel!
    @IBOutlet fileprivate weak var headerView: UIView!
    @IBOutlet fileprivate weak var emailNotificationsSwitch: UISwitch!
    @IBOutlet fileprivate weak var pushNotificationsSwitch: UISwitch!
    @IBOutlet fileprivate weak var versionLabel: UILabel!
    
    fileprivate let interactor: AccountInteracting & ApplicationSharing
    fileprivate var activityPresenter: PresentingActivity!

    init(interactor: AccountInteracting & ApplicationSharing) {
        self.interactor = interactor
        super.init(nibName: AccountViewController.nibName, bundle: nil)
        self.interactor.viewController = self
        self.interactor.errorPresenter = self
        self.interactor.activityLoaderPresenter = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpHeaderView()
        setUp(activityPresenter: ServiceLocator.activityPresenter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
    }
    
    @IBAction func didTapViewProfile() {
        interactor.didTapViewProfile()
    }
    
    @IBAction func didTapTermsOfService() {
        interactor.didTapTermsOfService()
    }
    
    @IBAction func didTapFaq() {
        interactor.didTapFaq()
    }
    
    @IBAction func didTapFoundABug() {
        interactor.didTapFoundABug()
    }
    
    @IBAction func didTapDeleteAccount() {
        interactor.didTapDeleteAccount()
    }
    
    @IBAction func didSwitchEmailNotifications() {
        interactor.didSwitchEmailNotifications(value: emailNotificationsSwitch.isOn)
    }
    
    @IBAction func didSwitchPushNotifications() {
        interactor.didSwitchPushNotifications(value: pushNotificationsSwitch.isOn)
    }
}

extension AccountViewController {
    fileprivate func setUpHeaderView() {
        headerView.applyGradient(withColors: [.lightGray, .white], gradientOrientation: .vertical)
    }
    
    fileprivate func setUpNavigationBar() {
        let share = UIBarButtonItem(title: Constants.shareTitle,
                                   style: .plain,
                                   target: interactor,
                                   action: #selector(ApplicationSharing.didTapShare))
        navigationItem.rightBarButtonItem = share
    }
    
    fileprivate func setUp(activityPresenter: PresentingActivity) {
        self.activityPresenter = activityPresenter
    }
}

extension AccountViewController: AccountControlling {
    func setAvatar(imageFetcher: ImageFetcher) {
        avatarImageView.fetchImage(using: imageFetcher, placeholder: #imageLiteral(resourceName: "circleLogo"))
    }
    
    func setInfluencerLabel(text: String) {
        influencerNameLabel.text = text
    }
    
    func setVersionLabel(text: String) {
        versionLabel.text = text
    }
    
    func setEmailStatus(emailStatus: Bool) {
        emailNotificationsSwitch.setOn(emailStatus, animated: true)
    }
    
    func setPushStatus(pushStatus: Bool) {
        pushNotificationsSwitch.setOn(pushStatus, animated: true)
    }
}

extension AccountViewController: ActivityLoaderPresenting {
    func showActivityLoader() {
        activityPresenter.presentActivity(inView: view)
    }
    
    func hideActivityLoader() {
        activityPresenter.dismissActivity(inView: view)
    }
}
