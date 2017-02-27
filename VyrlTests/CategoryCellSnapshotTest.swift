//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CategoryCellSnapshotTest: SnapshotTestCase {

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let view = Vyrl.CategoryCell.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
        let renderable = CategoryCellRenderable(name: "O Me! O Life!")

        view.render(renderable)

        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
