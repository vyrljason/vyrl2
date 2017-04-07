//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesInteractorNoDataMock: MessagesInteracting, DataRefreshing {
    weak var viewController: MessagesControlling?
    weak var errorPresenter: ErrorAlertPresenting?
    weak var messageDisplayer: MessageDisplaying?
    weak var composePresenter: ComposePresenting?
    weak var sendStatusPresenter: PresentingSendStatus?
    
    func viewDidLoad() { }

    func didTapMore() { }

    func didTapSend(message: String, addMessageStatus: AddMessageStatus) { }
    
    func use(_ tableView: UITableView) { }
    
    func refreshData() { }
}

final class MessagesControllerSnapshotTest: SnapshotTestCase {
    
    private var subject: MessagesViewController!
    private var interactor: MessagesInteractorNoDataMock!
    
    override func setUp() {
        super.setUp()
        interactor = MessagesInteractorNoDataMock()
        subject = MessagesViewController(interactor: interactor)
        
        recordMode = false
    }
    
    func testMessagesWithNoData() {
        _ = subject.view
        
        verifyForScreens(view: subject.view)
    }
    
    func testMessagesWithTextTyped() {
        _ = subject.view
        let testText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla egestas euismod venenatis. Phasellus placerat fringilla dui at lobortis."
        subject.messageTextView.text = testText
    
        verifyForScreens(view: subject.view)
    }
    
    func testMessagesWithNoDataAddingInstagramLink() {
        _ = subject.view
        subject.setUpAddMessageView(withStatus: .instagramLink)
        
        verifyForScreens(view: subject.view)
    }
    
    func testMessagesWithTextTypedAddingInstagramLink() {
        _ = subject.view
        subject.setUpAddMessageView(withStatus: .instagramLink)
        let testText = "http://www.test.com"
        subject.messageTextView.text = testText
        
        verifyForScreens(view: subject.view)
    }
}
