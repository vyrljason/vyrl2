//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Constants {
    static let failedToFetchPossibleIndustries: String = NSLocalizedString("editProfile.error.failedToFetchPossibleIndustries", comment: "")
}

@objc protocol EditProfileInteracting {
    weak var controller: EditProfileControlling? { get set }
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    func viewDidLoad()
    func didTapIndustry(textfield: UITextField)
    func didTapAvatar()
    func didTapBackground()
}

final class EditProfileInteractor: NSObject, EditProfileInteracting {
    
    fileprivate let industriesService: IndustriesProviding
    fileprivate let userProfile: UserProfile
    fileprivate let picker: PickerPresenting
    fileprivate var possibleIndustriesNames: [String] = []
    fileprivate var isPickingAvatar = false
    
    weak var controller: EditProfileControlling?
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter?
    weak var errorPresenter: ErrorAlertPresenting?
    
    init(userProfile: UserProfile, industriesService: IndustriesProviding) {
        self.userProfile = userProfile
        self.industriesService = industriesService
        self.picker = PickerPresenter()
    }
    
    func viewDidLoad() {
        fetchPossibleIndustries()
        setUpView()
    }
    
    func didTapIndustry(textfield: UITextField) {
        picker.showPicker(within: textfield, with: possibleIndustriesNames, defaultValue: textfield.text) { pickedIndustryName in
            textfield.text = pickedIndustryName
        }
    }
    
    func didTapAvatar() {
        isPickingAvatar = true
        controller?.showImagePicker()
    }
    
    func didTapBackground() {
        controller?.showImagePicker()
    }
    
    fileprivate func setUpView() {
        setAvatar()
        setBackground()
        controller?.setInfluencerUsername(text: userProfile.username)
        controller?.setInfluencerFullName(text: userProfile.fullName)
        setIndustries()
        controller?.setBioTextView(text: userProfile.bio)
        controller?.setEmailLabel(text: userProfile.email)
    }
    
    fileprivate func setAvatar() {
        guard let avatarUrl = userProfile.avatar else { return }
        controller?.setAvatar(imageFetcher: ImageFetcher(url: avatarUrl))
    }
    
    fileprivate func setBackground() {
        guard let backgroundUrl = userProfile.discoveryFeedImage else { return }
        controller?.setBackground(imageFetcher: ImageFetcher(url: backgroundUrl))
    }
    
    fileprivate func setIndustries() {
        userProfile.industries.enumerated().forEach { (index, industry) in
            switch index {
            case 0:
                controller?.setPrimaryIndustry(text: industry.name)
            case 1:
                controller?.setSecondaryIndustry(text: industry.name)
            case 2:
                controller?.setTertiaryIndustry(text: industry.name)
            default:
                return
            }
        }
    }
    
    fileprivate func fetchPossibleIndustries() {
        activityIndicatorPresenter?.presentActivity()
        industriesService.get { [weak self] result in
            self?.activityIndicatorPresenter?.dismissActivity()
            result.on(success: { industries in
                industries.forEach({ industry in
                    self?.possibleIndustriesNames.append(industry.name)
                })
            }, failure: { _ in
                self?.errorPresenter?.presentError(title: nil, message: Constants.failedToFetchPossibleIndustries)
            })
        }
    }
}

extension EditProfileInteractor: ImagePicking {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        controller?.closeImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if isPickingAvatar {
                controller?.setAvatar(image: pickedImage)
                isPickingAvatar = false
            } else {
                controller?.setBackground(image: pickedImage)
            }
        }
        controller?.closeImagePicker()
    }
}
