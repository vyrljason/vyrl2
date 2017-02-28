//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class UserDefaultsMock: ObjectStoring {
    var object: Any?

    func set(_ value: Any?, forKey defaultName: String) {
        object = value
    }

    func object(forKey defaultName: String) -> Any? {
        return object
    }
}

final class CartStorageTests: XCTestCase {

    var subject: CartStorage!
    var userDefaults: UserDefaultsMock!

    override func setUp() {
        super.setUp()

        userDefaults = UserDefaultsMock()
        subject = CartStorage(userDefaults: userDefaults)
    }

    func test_addItem_addedToDefaults() {
        subject.add(item: CartItem(id: "0", addedAt: Date()))

        expectToEventuallyBeTrue({ return self.userDefaults.object != nil }(), timeout: 0.1)
    }

    func test_addItem_added() {
        subject.add(item: CartItem(id: "0", addedAt: Date()))

        XCTAssertEqual(subject.items.count, 1)
    }

    func test_addItem_then_remove_zeroItems() {
        let item = CartItem(id: "0", addedAt: Date())
        subject.add(item: item)
        subject.remove(item: item)

        XCTAssertEqual(subject.items.count, 0)
    }

    func test_addItem_sorted() {
        let item0 = CartItem(id: "0", addedAt: Date(timeIntervalSince1970: 3600))
        let item1 = CartItem(id: "1", addedAt: Date(timeIntervalSince1970: 0))

        subject.add(item: item0)
        subject.add(item: item1)

        XCTAssertEqual(subject.items.first, item0)
        XCTAssertEqual(subject.items.last, item1)
    }
}
