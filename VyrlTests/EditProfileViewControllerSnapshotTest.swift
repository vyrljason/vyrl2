//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class EditProfileInteractorMock: NSObject, EditProfileInteracting, ImagePicking {
    weak var controller: EditProfileControlling?
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter?
    weak var errorPresenter: ErrorAlertPresenting?
    weak var accountReturner: AccountReturning?
    
    func viewDidLoad() { }
    
    func didTapIndustry(textfield: UITextField) { }
    
    func didTapAvatar() { }
    
    func didTapBackground() { }
    
    func didTapSave(fullName: String, bio: String, userIndustries: UpdatedUserIndustries) { }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { }
}

final class EditProfileViewControllerSnapshotTest: SnapshotTestCase {
    
    private var subject: EditProfileViewController!
    private var interactor: EditProfileInteractorMock!
    
    override func setUp() {
        super.setUp()
        interactor = EditProfileInteractorMock()
        subject = EditProfileViewController(interactor: interactor)
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let _ = subject.view
        
        verifyForScreens(view: subject.view)
    }
}
