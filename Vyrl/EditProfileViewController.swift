//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol EditProfileControlling: class {
    func setAvatar(imageFetcher: ImageFetcher)
    func setBackground(imageFetcher: ImageFetcher)
    func setInfluencerLabel(text: String)
    func setIndustryLabel(text: String)
    func setBioTextView(text: String)
}

final class EditProfileViewController: UIViewController, HavingNib {
    static var nibName: String = "EditProfileViewController"
    
    @IBOutlet fileprivate weak var avatarImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var backgroundImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var influencerNameLabel: UILabel!
    @IBOutlet fileprivate weak var influencerIndustryLabel: UILabel!
    @IBOutlet fileprivate weak var influencerBioTextView: AutoexpandableTextView!
    
    fileprivate var interactor: EditProfileInteracting
    
    init(interactor: EditProfileInteracting) {
        self.interactor = interactor
        super.init(nibName: EditProfileViewController.nibName, bundle: nil)
        self.interactor.controller = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
    }
}

extension EditProfileViewController {
    
    fileprivate func setUpNavigationBar() {
        renderNoTitleBackButton()
    }
}

extension EditProfileViewController: EditProfileControlling {
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
