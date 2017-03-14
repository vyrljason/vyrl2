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
        subject.translatesAutoresizingMaskIntoConstraints = false
        subject.set(height: 36)
        subject.set(width: 46)

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
}
