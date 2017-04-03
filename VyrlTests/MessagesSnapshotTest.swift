//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesInteractorNoDataMock: MessagesInteracting, DataRefreshing {
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var presenter: (MessageDisplaying & ErrorAlertPresenting)?
    weak var viewController: MessagesControlling?
    
    func viewWillAppear() { }

    func viewWillDisappear() { }
    
    func didTapMore() { }

    func didTapSend(message: String) { }
    
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
    
}
