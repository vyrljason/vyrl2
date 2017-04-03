//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesServiceTest: XCTestCase {
    
    private var subject: MessagesService!
    private var chatDatabase: ChatDatabaseMock!

    override func setUp() {
        super.setUp()
        chatDatabase = ChatDatabaseMock()
        chatDatabase.child = ChatDatabaseMock()
        subject = MessagesService(chatDatabase: chatDatabase)
    }
}
