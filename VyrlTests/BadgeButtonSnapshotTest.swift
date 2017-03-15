//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ButtonWithBadgeSnapshotTest: SnapshotTestCase {

    private var subject: ButtonWithBadge!

    override func setUp() {
        super.setUp()
        subject = ButtonWithBadge.badgeButton(with: #imageLiteral(resourceName: "iosCartIconNav"), action: { })
        subject.frame = CGRect(x: 0, y: 0, width: 46, height: 36)

        recordMode = false
    }

    func test_whenItemsCountIsZero_hidesBadge() {

        subject.render(BadgeButtonRenderable(itemsCount: 0))

        FBSnapshotVerifyView(subject)
        FBSnapshotVerifyLayer(subject.layer)
    }

    func test_whenItemsCountIsNonZero_showsBadge() {

        subject.render(BadgeButtonRenderable(itemsCount: 35))

        FBSnapshotVerifyView(subject)
        FBSnapshotVerifyLayer(subject.layer)
    }

    func test_whenItemsCountIs3Digits_showsBiggerBadge() {

        subject.render(BadgeButtonRenderable(itemsCount: 333))

        FBSnapshotVerifyView(subject)
        FBSnapshotVerifyLayer(subject.layer)
    }
}
