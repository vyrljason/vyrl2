//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import FBSnapshotTestCase

final class BrandStoreCellSnapshotTest: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let view = BrandStoreCell.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 187, height: 259)
        let product = Product(id: "id",
                              name: "Very bright and looong lens",
                              description: "Description",
                              category: "category",
                              brandId: "",
                              retailPrice: 20999.99,
                              isAdditionalGuidelines: true,
                              additionalGuidelines: "guidelines",
                              images: [],
                              variants: [])
        let renderable = BrandStoreCellRenderable(product: product)
        view.render(renderable)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
