//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CenteredWithDetailTableCellTest: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let view = CenteredWithDetailTableCell.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 52)
        let product = Product(id: "id",
                              name: "Very bright and looong lens",
                              description: "Description",
                              brandId: "",
                              retailPrice: 20999.99,
                              imageUrls: [])
        let renderable = NamePriceTableCellRenderable(product: product)
        view.render(renderable)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
