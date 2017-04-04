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

final class NotificationPostMock: NotificationPosting {
    var cartUpdate: CountableItemUpdate?

    func post(name aName: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]?) {
        cartUpdate = CountableItemUpdate(dictionary: aUserInfo)
    }
}

final class CartStorageTests: XCTestCase {

    private var subject: CartStorage!
    private var userDefaults: UserDefaultsMock!
    private var notificationPosting: NotificationPostMock!

    override func setUp() {
        super.setUp()
        notificationPosting = NotificationPostMock()
        userDefaults = UserDefaultsMock()
        subject = CartStorage(objectsStorage: userDefaults, notificationPosting: notificationPosting)
    }

    func test_addItem_addedToDefaults() {
        subject.add(item: VyrlFaker.faker.cartItem())

        expectToEventuallyBeTrue({ return self.userDefaults.object != nil }(), timeout: 0.5)
    }

    func test_addItem_added() {
        subject.add(item: VyrlFaker.faker.cartItem())

        XCTAssertEqual(subject.items.count, 1)
    }

    func test_addItem_then_remove_zeroItems() {
        let item = VyrlFaker.faker.cartItem()
        subject.add(item: item)
        subject.remove(item: item)

        XCTAssertEqual(subject.items.count, 0)
    }

    func test_addItem_postsUpdate() {
        subject.add(item: VyrlFaker.faker.cartItem())

        XCTAssertNotNil(notificationPosting.cartUpdate)
    }

    func test_addItem_sorted() {
        let item0 = CartItem(productId: "0", addedAt: Date(timeIntervalSince1970: 3600), productVariants: [])
        let item1 = CartItem(productId: "1", addedAt: Date(timeIntervalSince1970: 0), productVariants: [])

        subject.add(item: item0)
        subject.add(item: item1)

        XCTAssertEqual(subject.items.first, item0)
        XCTAssertEqual(subject.items.last, item1)
    }

    func test_removeItem_postsUpdate() {
        let item0 = CartItem(productId: "0", addedAt: Date(timeIntervalSince1970: 3600), productVariants: [])

        subject.remove(item: item0)

        XCTAssertNotNil(notificationPosting.cartUpdate)
    }

    func test_clear_removesAllItems() {
        subject.add(item: VyrlFaker.faker.cartItem())
        subject.add(item: VyrlFaker.faker.cartItem())
        subject.add(item: VyrlFaker.faker.cartItem())
        XCTAssertEqual(subject.items.count, 3)

        subject.clear()

        XCTAssertEqual(subject.items.count, 0)
    }

    func test_clear_postsUpdate() {
        subject.clear()

        XCTAssertNotNil(notificationPosting.cartUpdate)
    }
}
