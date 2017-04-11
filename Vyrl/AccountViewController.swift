//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class AccountViewController: UIViewController, HavingNib {
    static var nibName: String = "AccountViewController"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var influencerNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!

    init() {
        super.init(nibName: AccountViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeaderView()
    }
    
    fileprivate func setUpHeaderView() {
        headerView.applyGradient(withColors: [.lightGray, .white], gradientOrientation: .vertical)
    }
    
    @IBAction func didTapViewProfile(_ sender: Any) {
    }
    
    @IBAction func didTapTermsOfService(_ sender: Any) {
    }
    
    @IBAction func didTapFaq(_ sender: Any) {
    }
    
    @IBAction func didTapFoundABug(_ sender: Any) {
    }
    
    @IBAction func didTapDeleteAccount(_ sender: Any) {
    }
    
    @IBAction func didSwitchEmailNotifications(_ sender: Any) {
    }
    
    @IBAction func didSwitchPushNotifications(_ sender: Any) {
    }
}
