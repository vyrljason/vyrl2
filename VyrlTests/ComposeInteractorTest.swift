//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ComposeErrorPresenterMock: ErrorAlertPresenting {
    var didCallPresentError = false
    
    func presentError(title: String?, message: String?) {
        didCallPresentError = true
    }
}

final class ComposeCloserMock: ComposeClosing {
    var didCallFinishPresentation = false
    
    func finishPresentation() {
        didCallFinishPresentation = true
    }
}

final class ImageMessageSenderMock: ImageMessageSending {
    var success = true
    var error = ImageMessageError.imageUpload
    var response = EmptyResponse()
    
    func send(message: String, withImage image: UIImage, toCollab collab: Collab, completion: @escaping (Result<Void, ImageMessageError>) -> Void) {
        if success {
            completion(.success())
        } else {
            completion(.failure(error))
        }
    }
}

final class ComposeControllerMock: ComposeControlling {
    var didCallShowImagePicker = false
    var didCallCloseImagePicker = false
    var didCallSetUpImageView = false
    
    func showImagePicker() {
        didCallShowImagePicker = true
    }
    
    func closeImagePicker() {
        didCallCloseImagePicker = true
    }
    
    func setUpImageView(withImage image: UIImage) {
        didCallSetUpImageView = true
    }
}

final class ComposeInteractorTest: XCTestCase {
    
    var subject: ComposeInteractor!
    var closer: ComposeCloserMock!
    var messageSender: ImageMessageSenderMock!
    var errorPresenter: ComposeErrorPresenterMock!
    var viewController: ComposeControllerMock!
    var collab: Collab!
    
    override func setUp() {
        collab = VyrlFaker.faker.collab()
        closer = ComposeCloserMock()
        errorPresenter = ComposeErrorPresenterMock()
        messageSender = ImageMessageSenderMock()
        viewController = ComposeControllerMock()
        subject = ComposeInteractor(collab: collab, messageSender: messageSender)
        subject.composeCloser = closer
        subject.errorPresenter = errorPresenter
        subject.viewController = viewController
    }
    
    func test_didTapDone_whenMessageIsEmpty_doesNothing() {
        let message = ""
        let image: UIImage? = nil
        subject.selectedImage = image
        
        subject.didTapDone(message: message)
        
        XCTAssertFalse(closer.didCallFinishPresentation)
        XCTAssertFalse(errorPresenter.didCallPresentError)
    }
    
    func test_didTapSend_whenServiceReturnsError_presentsError() {
        let message = "message"
        let image = UIImage()
        subject.selectedImage = image
        messageSender.success = false
        
        subject.didTapDone(message: message)
        
        XCTAssertTrue(errorPresenter.didCallPresentError)
    }
    
    func test_didTapSend_whenServiceReturnsSuccess_clearsMessage() {
        let message = "message"
        let image = UIImage()
        subject.selectedImage = image
        messageSender.success = true
        
        subject.didTapDone(message: message)
        
        XCTAssertTrue(closer.didCallFinishPresentation)
    }
    
    func test_didTapClose_closesView() {
        subject.didTapClose()
        
        XCTAssertTrue(closer.didCallFinishPresentation)
    }
    
    func test_didTapImage_showsImagePicker() {
        subject.didTapImage()
        
        XCTAssertTrue(viewController.didCallShowImagePicker)
    }
}
