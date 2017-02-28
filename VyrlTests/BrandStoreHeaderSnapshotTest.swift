//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import FBSnapshotTestCase

final class BrandStoreHeaderSnapshotTest: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let view = BrandStoreHeader.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 180)
        let brand = Brand(id: "id", name: "GoPro",
                          description: "We make the World's Most Versatile Camera. This text is very long to show word wrapping at the end. This text is very long to show word wrapping at the end. This text is very long to show word wrapping at the end.",
                          submissionsCount: 3423,
                          coverImageURL: URL(string: "https://www.apple.com")!)
        let renderable = BrandStoreHeaderRenderable(brand: brand)
        view.render(renderable)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
