//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import FBSnapshotTestCase

final class BrandCellSnapshotTest: SnapshotTestCase {

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let view = BrandCell.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 188)
        let brand = Brand(id: "id", name: "GoPro",
                          description: "We make the World's Most Versatile Camera.",
                          submissionsCount: 3423,
                          coverImageURL: URL(string: "https://www.apple.com")!)
        let renderable = BrandRenderable(brand: brand)
        view.render(renderable)

        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
