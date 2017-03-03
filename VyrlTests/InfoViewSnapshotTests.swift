//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class InfoViewSnapshotTest: SnapshotTestCase {

    let text = NSAttributedString(string: "Oh me! Oh life! of the questions of these recurring, Of the endless trains of the faithless, of cities fill’d with the foolish", attributes: StyleKit.infoViewAttributes)

    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testViewCorrect() {
        let viewController = UIViewController()
        let _ = viewController.view

        let renderable = InfoViewRenderable(header: "Content guidelines",
                                            info: text,
                                            actionButtonTitle: "Done")

        let projector = InfoViewProjector(renderable: renderable)
        projector.presenter = viewController
        projector.display()

        verifyForScreens(view: viewController.view)
    }
}
