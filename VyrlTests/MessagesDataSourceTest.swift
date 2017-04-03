//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class MessagesServiceMock: MessagesProviding {
    var mockedMessages: [MessageContainer] = [VyrlFaker.faker.messageContainer()]

    func getMessages(inChatRoom chatRoomId: String, completion: @escaping ([MessageContainer]) -> Void) {
        completion(mockedMessages)
    }
}

final class ChatRoomUpdaterMock: ChatRoomUpdatesInforming {

    var didCallStopListening = false
    var didCallListenToNewMessages = false

    func listenToNewMessages(inRoom roomId: String, completion: @escaping ([MessageContainer]) -> Void) {
        didCallListenToNewMessages = true
    }

    func stopListening(inRoom roomId: String) {
        didCallStopListening = true
    }
}

final class MessagesDataSourceTests: XCTestCase {
    
    var subject: MessagesDataSource!
    var service: MessagesServiceMock!
    var tableView: TableViewMock!
    private var chatRoomUpdater: ChatRoomUpdaterMock!
    var collab: Collab!

    override func setUp() {
        super.setUp()
        service = MessagesServiceMock()
        tableView = TableViewMock()
        collab = VyrlFaker.faker.collab()
        chatRoomUpdater = ChatRoomUpdaterMock()
        subject = MessagesDataSource(collab: collab, chatRoomUpdater: chatRoomUpdater)
    }
    
    func test_registerNibs_didRegisterNib() {
        subject.use(tableView)
        
        XCTAssertTrue(tableView.didRegisterNib)
    }

    func test_use_setsDelegateAndDataSource_onTableView() {
        subject.use(tableView)
        
        XCTAssertTrue(tableView.didSetDataSource)
        XCTAssertTrue(tableView.dataSource === subject)
        XCTAssertTrue(tableView.didSetDelegation)
        XCTAssertTrue(tableView.delegate === subject)
    }

    func test_stopDataUpdates_asksChatUpdaterToStopUpdates() {

        subject.stopDataUpdates()

        XCTAssertTrue(chatRoomUpdater.didCallStopListening)
    }

    func test_loadData_startsListeningToUpdates() {

        subject.loadTableData()

        XCTAssertTrue(chatRoomUpdater.didCallListenToNewMessages)
    }
}
