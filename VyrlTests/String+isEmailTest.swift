//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class StringIsEmailTest: XCTestCase {

    func test_isEmail_ReturnsTrueWithValidExample() {
        let exampleEmail = "test@valid.email"

        XCTAssertTrue(exampleEmail.isEmail)
    }

    func test_isEmail_ReturnsFalseWithInvalidExample() {
        let exampleEmail = "test@invalid"

        XCTAssertFalse(exampleEmail.isEmail)
    }
}
