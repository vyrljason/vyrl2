//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Decodable
import XCTest
@testable import Vyrl

final class JSONModelDeserializerTest: XCTestCase {

    private var serializator: JSONSerializationMock.Type!

    override func setUp() {
        serializator = JSONSerializationMock.self
    }

    func test_deserializeModel_WithSerializationError_ThrowsError() {
        let data = "{}".data(using: String.Encoding.utf8)!
        serializator.nextError = NSError(domain: "test_error", code: 444, userInfo: nil)
        let subject = JSONModelDeserializer(serializator: serializator)

        do {
            let _: MockUser = try subject.deserialize(data: data, model: MockUser.self)
            XCTFail("Model shouldn't be created when error occurs")
        } catch { }
    }

    func test_deserializeModel_WithModelData_ReturnModelInstance() {
        serializator.nextError = nil
        let validJSON = ["username": "test_user", "email": "email@email.com"]
        let expectedModel = MockUser(username:  validJSON["username"]!, email:  validJSON["email"]!)
        let responseData = try? JSONSerialization.data(withJSONObject: validJSON, options: JSONSerialization.WritingOptions())
        serializator.nextObject = validJSON as Any

        let subject = JSONModelDeserializer(serializator: serializator)
        let model: MockUser? = try? subject.deserialize(data: responseData!, model: MockUser.self)

        XCTAssertEqual(expectedModel, model)
    }
}
