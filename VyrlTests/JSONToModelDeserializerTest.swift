//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
@testable import Vyrl

final class JSONToModelDeserializerTest: XCTestCase {

    private var subject: JSONToModelDeserializer!

    override func setUp() {
        subject = JSONToModelDeserializer()
    }

    func test_deserialize_WithModelDecodingError_ThrowsError() {
        let invalidJSON = ["usernadsdsme": "test_user", "email": "email@email.com"]

        XCTAssertThrowsError(try subject.deserialize(json: invalidJSON, model: MockUser.self))
    }

    func test_deserialize_WithModelData_ReturnModelInstance() {
        let validJSON = ["username": "test_user", "email": "email@email.com"]
        let expectedModel = MockUser(username:  validJSON["username"]!, email:  validJSON["email"]!)

        let model: MockUser? = try? subject.deserialize(json: validJSON, model: MockUser.self)

        XCTAssertEqual(expectedModel, model)

    }
}
