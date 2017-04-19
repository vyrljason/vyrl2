//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let selectIndustry: String = NSLocalizedString("editProfile.industry.select", comment: "")
}

@objc protocol EditProfileControlling: class {
    func setAvatar(imageFetcher: ImageFetcher)
    func setBackground(imageFetcher: ImageFetcher)
    func setAvatar(image: UIImage)
    func setBackground(image: UIImage)
    func setInfluencerUsername(text: String)
    func setInfluencerFullName(text: String)
    func setPrimaryIndustry(text: String?)
    func setSecondaryIndustry(text: String?)
    func setTertiaryIndustry(text: String?)
    func setEmailLabel(text: String?)
    func setBioTextView(text: String)
    func showImagePicker()
    func closeImagePicker()
}

final class EditProfileViewController: UIViewController, HavingNib {
    static var nibName: String = "EditProfileViewController"
    
    @IBOutlet fileprivate weak var avatarImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var backgroundImageView: DownloadingImageView!
    @IBOutlet fileprivate weak var influencerNameLabel: UILabel!
    @IBOutlet fileprivate weak var influencerFullNameTextField: UITextField!
    @IBOutlet fileprivate weak var primaryIndustryTextField: UITextField!
    @IBOutlet fileprivate weak var secondaryIndustryTextField: UITextField!
    @IBOutlet fileprivate weak var tertiaryIndustryTextField: UITextField!
    @IBOutlet fileprivate weak var primaryIndustryView: UIView!
    @IBOutlet fileprivate weak var secondaryIndustryView: UIView!
    @IBOutlet fileprivate weak var tertiaryIndustryView: UIView!
    @IBOutlet fileprivate weak var influencerBioTextView: AutoexpandableTextView!
    @IBOutlet fileprivate weak var influencerEmailLabel: UILabel!
    
    fileprivate var interactor: EditProfileInteracting & ImagePicking
    fileprivate var activityPresenter: PresentingActivity!
    fileprivate var imagePicker: UIImagePickerController!
    
    init(interactor: EditProfileInteracting & ImagePicking) {
        self.interactor = interactor
        super.init(nibName: EditProfileViewController.nibName, bundle: nil)
        self.interactor.controller = self
        self.interactor.activityIndicatorPresenter = self
        self.interactor.errorPresenter = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(activityPresenter: ServiceLocator.activityPresenter)
        setUp(imagePicker: UIImagePickerController())
        setUpNavigationBar()
        setUpIndustriesViews()
        setUpImageViews()
        interactor.viewDidLoad()
    }
}

extension EditProfileViewController {
    fileprivate func setUpNavigationBar() {
        renderNoTitleBackButton()
    }
    
    fileprivate func setUp(activityPresenter: PresentingActivity) {
        self.activityPresenter = activityPresenter
    }
    
    fileprivate func setUpIndustriesViews() {
        let primaryTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPrimaryIndustry))
        primaryIndustryView.addGestureRecognizer(primaryTapGesture)
        let secondaryTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSecondaryIndustry))
        secondaryIndustryView.addGestureRecognizer(secondaryTapGesture)
        let tertiaryTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTertiaryIndustry))
        tertiaryIndustryView.addGestureRecognizer(tertiaryTapGesture)
    }
    
    fileprivate func setUpImageViews() {
        avatarImageView.isUserInteractionEnabled = true
        let avatarTapGesture = UITapGestureRecognizer(target: interactor, action: #selector(EditProfileInteracting.didTapAvatar))
        avatarImageView.addGestureRecognizer(avatarTapGesture)
        backgroundImageView.isUserInteractionEnabled = true
        let backgroundTapGesture = UITapGestureRecognizer(target: interactor, action: #selector(EditProfileInteracting.didTapBackground))
        backgroundImageView.addGestureRecognizer(backgroundTapGesture)
    }
    
    @objc fileprivate func didTapPrimaryIndustry() {
        interactor.didTapIndustry(textfield: primaryIndustryTextField)
    }
    
    @objc fileprivate func didTapSecondaryIndustry() {
        interactor.didTapIndustry(textfield: secondaryIndustryTextField)
    }
    
    @objc fileprivate func didTapTertiaryIndustry() {
        interactor.didTapIndustry(textfield: tertiaryIndustryTextField)
    }
    
    fileprivate func setUp(imagePicker: UIImagePickerController) {
        self.imagePicker = imagePicker
        imagePicker.delegate = interactor
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
}

extension EditProfileViewController: EditProfileControlling {
    func setAvatar(imageFetcher: ImageFetcher) {
        avatarImageView.fetchImage(using: imageFetcher, placeholder: #imageLiteral(resourceName: "circleLogo"))
    }
    
    func setBackground(imageFetcher: ImageFetcher) {
        backgroundImageView.fetchImage(using: imageFetcher, placeholder: #imageLiteral(resourceName: "logoWhiteCopy"))
    }
    
    func setAvatar(image: UIImage) {
        avatarImageView.image = image
    }
    
    func setBackground(image: UIImage) {
        backgroundImageView.image = image
    }
    
    func setPrimaryIndustry(text: String?) {
        primaryIndustryTextField.text = text
    }
    
    func setSecondaryIndustry(text: String?) {
        secondaryIndustryTextField.text = text
    }
    
    func setTertiaryIndustry(text: String?) {
        tertiaryIndustryTextField.text = text
    }
    
    func setInfluencerUsername(text: String) {
        influencerNameLabel.text = text
    }
    
    func setInfluencerFullName(text: String) {
        influencerFullNameTextField.text = text
    }
    
    func setBioTextView(text: String) {
        influencerBioTextView.text = text
    }
    
    func setEmailLabel(text: String?) {
        influencerEmailLabel.text = text
    }
    
    func showImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func closeImagePicker() {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: ActivityIndicatorPresenter {
    
    func presentActivity() {
        activityPresenter.presentActivity(inView: view)
    }
    
    func dismissActivity() {
        activityPresenter.dismissActivity(inView: view)
    }
}
