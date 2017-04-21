//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ProfileInteractorMock: ProfileInteracting {
    weak var controller: ProfileControlling?
    weak var editProfilePresenter: EditProfilePresenting?
    
    func viewWillAppear() { }
    
    func didTapEdit() { }
}

final class ProfileViewControllerSnapshotTest: SnapshotTestCase {
    
    private var subject: ProfileViewController!
    private var interactor: ProfileInteractorMock!
    
    override func setUp() {
        super.setUp()
        interactor = ProfileInteractorMock()
        subject = ProfileViewController(interactor: interactor)
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let _ = subject.view
        
        verifyForScreens(view: subject.view)
    }
}
