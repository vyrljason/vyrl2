//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ComposeInteractorMock: NSObject, ComposeInteracting, ImagePicking {
    weak var composeCloser: ComposeClosing?
    weak var viewController: ComposeControlling?
    weak var errorPresenter: ErrorAlertPresenting?
    func didTapClose() { }
    func didTapDone(message: String) { }
    func didTapImage() { }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { }
}

final class ComposeViewControllerSnapshotTest: SnapshotTestCase {
    
    private var subject: ComposeViewController!
    private var interactor: ComposeInteractorMock!
    
    override func setUp() {
        super.setUp()
        interactor = ComposeInteractorMock()
        subject = ComposeViewController(interactor: interactor)
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let _ = subject.view
        
        verifyForScreens(view: subject.view)
    }
}
