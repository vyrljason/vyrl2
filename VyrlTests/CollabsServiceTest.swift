//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

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
