//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class SuccessMessagesFooterViewSnapshotTest: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
    }
    
    func testViewCorrect() {
        let view = SuccessMessagesFooterView.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 176)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
