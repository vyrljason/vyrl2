//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesInteractorNoDataMock: MessagesInteracting {
    
    func viewWillAppear() { }
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
}
