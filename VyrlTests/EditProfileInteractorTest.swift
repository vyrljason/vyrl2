//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class IndustriesServiceMock: IndustriesProviding {
    var success = true
    var error = ServiceError.unknown
    var response = [Industry(id: 0, name: VyrlFaker.faker.lorem.word()),
                    Industry(id: 1, name: VyrlFaker.faker.lorem.word()),
                    Industry(id: 2, name: VyrlFaker.faker.lorem.word())]
    
    func get(completion: @escaping (Result<[Industry], ServiceError>) -> Void) {
        if success {
            completion(.success(response))
        } else {
            completion(.failure(error))
        }
    }
}

final class UpdateUserIndustriesServiceMock: UserIndustriesUpdating {
    var success = true
    var error = ServiceError.unknown
    var response = EmptyResponse()
    
    func update(updatedUserIndustries: UpdatedUserIndustries, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        if success {
            completion(.success(response))
        } else {
            completion(.failure(error))
        }
    }
}

final class UserProfileUpdaterMock: UserProfileUpdating {
    var success = true
    var error = UpdateUserProfileError.userProfileUpdate
    
    func update(avatarFilePath: URL?, discoverImageFilePath: URL?, userIndustries: UpdatedUserIndustries, fullName: String, bio: String, completion: @escaping (Result<Void, UpdateUserProfileError>) -> Void) {
        if success {
            completion(.success())
        } else {
            completion(.failure(error))
        }
    }
}

final class PickPresenterMock: PickerPresenting {
    var wasCalled = false
    
    func showPicker(within textField: UITextField, with data: [String], defaultValue: String?, onSelection: @escaping PickerCompletion) {
        wasCalled = true
    }
}

final class EditProfileControllerMock: EditProfileControlling {
    var didCallSetAvatarFromUrl = false
    var didCallSetAvatarFromImage = false
    var didCallSetBackgroundFromUrl = false
    var didCallSetBackgroundFromImage = false
    var didCallSetInfluencerUsername = false
    var didCallSetInfluencerFullName = false
    var didCallSetPrimaryIndustry = false
    var didCallSetSecondaryIndustry = false
    var didCallSetTertiaryIndustry = false
    var didCallSetEmailLabel = false
    var didCallSetBioTextView = false
    var didCallShowImagePicker = false
    var didCallCloseImagePicker = false
    
    func setAvatar(imageFetcher: ImageFetcher) {
        didCallSetAvatarFromUrl = true
    }
    func setBackground(imageFetcher: ImageFetcher) {
        didCallSetBackgroundFromUrl = true
    }
    func setAvatar(image: UIImage) {
        didCallSetAvatarFromImage = true
    }
    func setBackground(image: UIImage) {
        didCallSetBackgroundFromImage = true
    }
    func setInfluencerUsername(text: String?) {
        didCallSetInfluencerUsername = true
    }
    func setInfluencerFullName(text: String?) {
        didCallSetInfluencerFullName = true
    }
    func setPrimaryIndustry(text: String?) {
        didCallSetPrimaryIndustry = true
    }
    func setSecondaryIndustry(text: String?) {
        didCallSetSecondaryIndustry = true
    }
    func setTertiaryIndustry(text: String?) {
        didCallSetTertiaryIndustry = true
    }
    func setEmailLabel(text: String?) {
        didCallSetEmailLabel = true
    }
    func setBioTextView(text: String?) {
        didCallSetBioTextView = true
    }
    func showImagePicker() {
        didCallShowImagePicker = true
    }
    func closeImagePicker() {
        didCallCloseImagePicker = true
    }
}

final class AccountReturnerMock: AccountReturning {
    var wasCalled = false
    
    func returnToAccount(animated: Bool) {
        wasCalled = true
    }
}

final class EditProfileInteractorTest: XCTestCase {
    
    var subject: EditProfileInteractor!
    var industriesService: IndustriesServiceMock!
    var userProfileUpdater: UserProfileUpdaterMock!
    var userProfile: UserProfile!
    var picker: PickPresenterMock!
    var controller: EditProfileControllerMock!
    var activityIndicatorPresenter: ActivityIndicatorPresenterMock!
    var errorPresenter: ErrorPresenterMock!
    var accountReturner: AccountReturnerMock!
    
    override func setUp() {
        industriesService = IndustriesServiceMock()
        errorPresenter = ErrorPresenterMock()
        userProfileUpdater = UserProfileUpdaterMock()
        userProfile = VyrlFaker.faker.userProfile(industries: [VyrlFaker.faker.industry(),
                                                               VyrlFaker.faker.industry(),
                                                               VyrlFaker.faker.industry()])
        picker = PickPresenterMock()
        controller = EditProfileControllerMock()
        activityIndicatorPresenter = ActivityIndicatorPresenterMock()
        accountReturner = AccountReturnerMock()
        
        subject = EditProfileInteractor(userProfile: userProfile, industriesService: industriesService, userProfileUpdater: userProfileUpdater, picker: picker)
        subject.controller = controller
        subject.errorPresenter = errorPresenter
        subject.activityIndicatorPresenter = activityIndicatorPresenter
        subject.accountReturner = accountReturner
    }
    
    func test_onViewDidLoad_setUpView() {
        subject.viewDidLoad()
        
        XCTAssertTrue(controller.didCallSetAvatarFromUrl)
        XCTAssertTrue(controller.didCallSetBackgroundFromUrl)
        XCTAssertTrue(controller.didCallSetEmailLabel)
        XCTAssertTrue(controller.didCallSetBioTextView)
        XCTAssertTrue(controller.didCallSetInfluencerFullName)
        XCTAssertTrue(controller.didCallSetInfluencerUsername)
    }
    
    func test_didTapSave_updateProfile_success() {
        subject.viewDidLoad()
        subject.didTapSave(fullName: "", bio: "")
        
        XCTAssertTrue(accountReturner.wasCalled)
        XCTAssertFalse(errorPresenter.didPresentError)
    }
    
    func test_didTapSave_updateProfile_failure() {
        userProfileUpdater.success = false
        subject.didTapSave(fullName: "", bio: "")
        
        XCTAssertFalse(accountReturner.wasCalled)
        XCTAssertTrue(errorPresenter.didPresentError)
    }
    
    func test_didTapIndustry_callPresenter() {
        subject.didTapIndustry(textfield: UITextField(), editProfileIndustry: .primary)
        
        XCTAssertTrue(picker.wasCalled)
    }
    
    func test_didTapAvatar_callPresenter() {
        subject.didTapAvatar()
        
        XCTAssertTrue(controller.didCallShowImagePicker)
    }
    
    func test_didTapBackgroundImage_callPresenter() {
        subject.didTapBackground()
        
        XCTAssertTrue(controller.didCallShowImagePicker)
    }
}
