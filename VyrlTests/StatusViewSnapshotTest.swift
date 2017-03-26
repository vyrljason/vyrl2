//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class StatusViewSnapshotTest: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = true
    }
    
    func testViewWaitingForResposne() {
        let view = StatusView(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        let collabStatus = CollabStatus.waiting
        let renderable = StatusViewRenderable(status: collabStatus)
        view.render(renderable: renderable)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
    
    func testViewPublicationCollapsed() {
        let view = StatusView(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        let collabStatus = CollabStatus.publication
        let renderable = StatusViewRenderable(status: collabStatus)
        view.render(renderable: renderable)
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
    
    func testViewPublicationExpanded() {
        let view = StatusView(frame: CGRect(x: 0, y: 0, width: 375, height: 264))
        let collabStatus = CollabStatus.publication
        let renderable = StatusViewRenderable(status: collabStatus)
        view.render(renderable: renderable)
        view.expandView()
        
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
}
