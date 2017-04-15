//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class AccountInteractorMock: AccountInteracting, ApplicationSharing {
    weak var controller: AccountControlling?
    weak var activityIndicatorPresenter: ActivityIndicatorPresenter?
    weak var errorPresenter: ErrorAlertPresenting?
    weak var webviewPresenter: WebviewPresenting?
    weak var sharePresenter: SharePresenting?
    
    func viewWillAppear() { }
    
    func didTapFaq() { }
    
    func didTapFoundABug() { }
    
    func didTapViewProfile() { }
    
    func didTapDeleteAccount() { }
    
    func didTapTermsOfService() { }
    
    func didSwitchPushNotifications(value: Bool) { }
    
    func didSwitchEmailNotifications(value: Bool) { }
    
    func didTapShare() { }
}

final class AccountViewControllerSnapshotTest: SnapshotTestCase {
    
    private var subject: AccountViewController!
    private var interactor: AccountInteractorMock!
    
    override func setUp() {
        super.setUp()
        interactor = AccountInteractorMock()
        subject = AccountViewController(interactor: interactor)
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let _ = subject.view
        
        verifyForScreens(view: subject.view)
    }
}
