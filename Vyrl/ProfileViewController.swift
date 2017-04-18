//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProfileControlling: class {
    func setAvatar(imageFetcher: ImageFetcher)
    func setBackground(imageFetcher: ImageFetcher)
    func setInfluencerLabel(text: String)
    func setIndustryLabel(text: String)
    func setBioTextView(text: String)
}

final class ProfileViewController: UIViewController, HavingNib {
    static var nibName: String = "ProfileViewController"
    
    @IBOutlet fileprivate weak var avatarImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var backgroundImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var influencerNameLabel: UILabel!
    @IBOutlet fileprivate weak var influencerIndustryLabel: UILabel!
    @IBOutlet fileprivate weak var influencerBioTextView: AutoexpandableTextView!
    
    fileprivate var interactor: ProfileInteracting
    
    init(interactor: ProfileInteracting) {
        self.interactor = interactor
        super.init(nibName: ProfileViewController.nibName, bundle: nil)
        self.interactor.controller = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
    }
    @IBAction func didTapEditButton() {
        interactor.didTapEdit()
    }
}

extension ProfileViewController {
    
    fileprivate func setUpNavigationBar() {
        renderNoTitleBackButton()
    }
}

extension ProfileViewController: ProfileControlling {
    func setAvatar(imageFetcher: ImageFetcher) {
        avatarImageView.fetchImage(using: imageFetcher, placeholder: #imageLiteral(resourceName: "circleLogo"))
    }
    
    func setBackground(imageFetcher: ImageFetcher) {
        backgroundImageView.fetchImage(using: imageFetcher, placeholder: #imageLiteral(resourceName: "logoWhiteCopy"))
    }
    
    func setIndustryLabel(text: String) {
        influencerIndustryLabel.text = text
    }
    
    func setInfluencerLabel(text: String) {
        influencerNameLabel.text = text
    }
    
    func setBioTextView(text: String) {
        influencerBioTextView.text = text
    }
}
