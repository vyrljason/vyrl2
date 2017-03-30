//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class MessagesServiceMock: MessagesProviding {
    var mockedMessages: [MessageContainer]? = [VyrlFaker.faker.messageContainer()]

    func getMessages(inChatRoom chatRoomId: String, completion: @escaping (Result<[MessageContainer], ServiceError>) -> Void) {
        switch mockedMessages {
        case .some(let messages):
            completion(.success(messages))
        case .none:
            completion(.failure(.unknown))
        }
    }
}

final class MessagesDataSourceTests: XCTestCase {
    
    var subject: MessagesDataSource!
    var service: MessagesServiceMock!
    var tableView: TableViewMock!
    var collab: Collab!

    override func setUp() {
        super.setUp()
        service = MessagesServiceMock()
        tableView = TableViewMock()
        collab = VyrlFaker.faker.collab()
        subject = MessagesDataSource(service: service, collab: collab)
    }
    
    func test_registerNibs_didRegisterNib() {
        subject.use(tableView)
        
        XCTAssertTrue(tableView.didRegisterNib)
    }
    
    func test_loadData_numberOfItemsInSection_One() {
        subject.loadTableData()
        
        XCTAssertEqual(subject.tableView(tableView, numberOfRowsInSection: 0), 1)
    }
    
    func test_use_setsDelegateAndDataSource_onTableView() {
        subject.use(tableView)
        
        XCTAssertTrue(tableView.didSetDataSource)
        XCTAssertTrue(tableView.dataSource === subject)
        XCTAssertTrue(tableView.didSetDelegation)
        XCTAssertTrue(tableView.delegate === subject)
    }
}
