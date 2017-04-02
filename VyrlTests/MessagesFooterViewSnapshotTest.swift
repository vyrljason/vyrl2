//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesFooterViewSnapshotTest: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
    }
    
    func testAddContentViewState() {
        let view = MessagesFooterView.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 60)
        let renderable = MessagesFooterRenderable(footerType: .addContent)
        view.render(renderable: renderable)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
    
    func testConfirmDeliveryViewState() {
        let view = MessagesFooterView.fromNib(translatesAutoresizingMaskIntoConstraints: true)
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 60)
        let renderable = MessagesFooterRenderable(footerType: .confirmDelivery)
        view.render(renderable: renderable)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
