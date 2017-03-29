//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Firebase

final class ChatDatabaseMock: ChatDatabaseChildAccessing, ChatDatabaseObserving {

    var child: ChatDatabaseMock!
    var didCallObserved = false
    var snapshot = FIRDataSnapshot()

    func childAt(path: String) -> ChatDatabaseChildAccessing & ChatDatabaseObserving {
        return child
    }

    func observe(_ eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Void) -> UInt {
        didCallObserved = true
        block(snapshot)
        return 0
    }

    func removeObserver(withHandle handle: UInt) { }

    func removeAllObservers() { }
}

final class CollabsServiceTest: XCTestCase {

    private var subject: CollabsService!
    private var chatDatabase: ChatDatabaseMock!
    private var credentialsStorage: ChatCredentialsStorageMock!
    private var brandsService: BrandsServiceMock!

    override func setUp() {
        super.setUp()
        brandsService = BrandsServiceMock()
        credentialsStorage = ChatCredentialsStorageMock()
        chatDatabase = ChatDatabaseMock()
        chatDatabase.child = ChatDatabaseMock()
        subject = CollabsService(chatDatabase: chatDatabase,
                                 chatCredentialsStorage: credentialsStorage,
                                 brandsService: brandsService)
    }

    func test_getCollabs_whenNoUserId_returnsFailure() {
        credentialsStorage.internalUserId = nil

        var wasCalled = false
        subject.getCollabs { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getCollabs_whenUserIDAndBrandsServiceIsSuccess_returnsSuccess() {
        credentialsStorage.internalUserId = "userId"
        brandsService.success = true

        var wasCalled = false
        subject.getCollabs { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getCollabs_whenBrandsServiceFails_returnsError() {
        credentialsStorage.internalUserId = "userId"
        brandsService.success = false

        var wasCalled = false
        subject.getCollabs { result in
            wasCalled = true
            expectToBeFailure(result)
        }
        XCTAssertTrue(wasCalled)
    }
}
