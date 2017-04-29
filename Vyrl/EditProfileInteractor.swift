//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Constants {
    static let failedToFetchPossibleIndustries: String = NSLocalizedString("editProfile.error.failedToFetchPossibleIndustries", comment: "")
    static let failedToUpdateUserProfile: String = NSLocalizedString("editProfile.error.failedToUpdateUserProfile", comment: "")
    static let allIndustriesNotSelected: String = NSLocalizedString("editProfile.error.allIndustriesNotSelected", comment: "")
}

@objc protocol EditProfileInteracting {
    weak var controller: EditProfileControlling? { get set }
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter? { get set }
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    weak var accountReturner: AccountReturning? { get set }
    func viewDidLoad()
    func didTapIndustry(textfield: UITextField, editProfileIndustry: EditProfileIndustry)
    func didTapAvatar()
    func didTapBackground()
    func didTapSave(fullName: String, bio: String)
}

@objc enum EditProfileIndustry: Int {
    case primary
    case secondary
    case tertiary
}

final class EditProfileInteractor: NSObject, EditProfileInteracting {
    
    fileprivate let industriesService: IndustriesProviding
    fileprivate let userProfileUpdater: UserProfileUpdating
    fileprivate let userProfile: UserProfile?
    fileprivate let picker: PickerPresenting
    fileprivate var possibleIndustriesNames: [String] = []
    fileprivate var possibleIndustries: [Industry] = []
    fileprivate var isPickingAvatar = false
    fileprivate var avatarFilePath: URL?
    fileprivate var backgroundImageFilePath: URL?
    fileprivate var primaryIndustry: Industry?
    fileprivate var secondaryIndustry: Industry?
    fileprivate var tertiaryIndustry: Industry?
    
    weak var controller: EditProfileControlling?
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter?
    weak var errorPresenter: ErrorAlertPresenting?
    weak var accountReturner: AccountReturning?
    
    init(userProfile: UserProfile?, industriesService: IndustriesProviding,
         userProfileUpdater: UserProfileUpdating, picker: PickerPresenting) {
        self.userProfile = userProfile
        self.industriesService = industriesService
        self.userProfileUpdater = userProfileUpdater
        self.picker = picker
    }
    
    func viewDidLoad() {
        fetchPossibleIndustries()
        setUpView()
    }
    
    func didTapIndustry(textfield: UITextField, editProfileIndustry: EditProfileIndustry) {
        picker.showPicker(within: textfield, with: possibleIndustriesNames, defaultValue: textfield.text) {[weak self] pickedIndustryName in
            guard let `self` = self else { return }
            let filteredIndustries = self.possibleIndustries.filter { $0.name == pickedIndustryName }
            guard let industry = filteredIndustries.first else { return }
            textfield.text = pickedIndustryName
            switch editProfileIndustry {
            case .primary:
                self.primaryIndustry = industry
            case .secondary:
                self.secondaryIndustry = industry
            case .tertiary:
                self.tertiaryIndustry = industry
            }
        }
    }
    
    func didTapAvatar() {
        isPickingAvatar = true
        controller?.showImagePicker()
    }
    
    func didTapBackground() {
        controller?.showImagePicker()
    }
    
    func didTapSave(fullName: String, bio: String) {
        activityIndicatorPresenter?.presentActivity()
        guard let primaryIndustry = primaryIndustry, let secondaryIndustry = secondaryIndustry, let tertiaryIndustry = tertiaryIndustry else {
            errorPresenter?.presentError(title: nil, message: Constants.allIndustriesNotSelected)
            return
        }
        let userIndustries = UpdatedUserIndustries(primaryIndustry: primaryIndustry, secondaryIndustry: secondaryIndustry, tertiaryIndustry: tertiaryIndustry)
        userProfileUpdater.update(avatarFilePath: avatarFilePath, discoverImageFilePath: backgroundImageFilePath,
                                  userIndustries: userIndustries, fullName: fullName, bio: bio) { [weak self] result in
                                    self?.activityIndicatorPresenter?.dismissActivity()
                                    result.on(success: { _ in
                                        self?.accountReturner?.returnToAccount(animated: true)
                                    }, failure: { _ in
                                        self?.errorPresenter?.presentError(title: nil, message: Constants.failedToUpdateUserProfile)
                                    })
        }
    }
    
    fileprivate func setUpView() {
        setAvatar()
        setBackground()
        controller?.setInfluencerUsername(text: userProfile?.username)
        controller?.setInfluencerFullName(text: userProfile?.fullName)
        setIndustries()
        controller?.setBioTextView(text: userProfile?.bio)
        controller?.setEmailLabel(text: userProfile?.email)
    }
    
    fileprivate func setAvatar() {
        guard let avatarUrl = userProfile?.avatar else { return }
        controller?.setAvatar(imageFetcher: ImageFetcher(url: avatarUrl))
    }
    
    fileprivate func setBackground() {
        guard let backgroundUrl = userProfile?.discoveryFeedImage else { return }
        controller?.setBackground(imageFetcher: ImageFetcher(url: backgroundUrl))
    }
    
    fileprivate func setIndustries() {
        userProfile?.industries.enumerated().forEach { (index, industry) in
            switch index {
            case 0:
                primaryIndustry = industry
                controller?.setPrimaryIndustry(text: industry.name)
            case 1:
                secondaryIndustry = industry
                controller?.setSecondaryIndustry(text: industry.name)
            case 2:
                tertiaryIndustry = industry
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
                let trimmedIndustries: [Industry] = industries.map {
                    industry -> (Industry) in
                    let newIndustry = Industry(id: industry.id, name: industry.name.replacingOccurrences(of: "_", with: " "))
                    return newIndustry
                }
                self?.possibleIndustries = trimmedIndustries
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
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            if isPickingAvatar {
                controller?.setAvatar(image: pickedImage)
                avatarFilePath = saveImageToFile(imageName: "avatar", image: pickedImage)
                isPickingAvatar = false
            } else {
                controller?.setBackground(image: pickedImage)
                backgroundImageFilePath = saveImageToFile(imageName: "dwi", image: pickedImage)
            }
        }
        controller?.closeImagePicker()
    }
    
    fileprivate func saveImageToFile(imageName: String, image: UIImage) -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let imageFilePathString = documentsPath.appending("/\(imageName).png")
        let imageFilePath = URL(fileURLWithPath: imageFilePathString)
        try? UIImageJPEGRepresentation(image, 0.5)?.write(to: imageFilePath, options: .atomic)
        return imageFilePath
    }
}
