//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import FBSnapshotTestCase
import UIKit

struct ViewportSizes {
    static let threePointFiveInchesPhoneFrame = CGRect(x: 0, y: 0, width: 320, height: 480)
    static let fourInchesPhoneFrame = CGRect(x: 0, y: 0, width: 320, height: 568)
    static let fourPointSevenInchesPhoneFrame = CGRect(x: 0, y: 0, width: 375, height: 667)
}

class SnapshotTestCase: FBSnapshotTestCase {

    private let frames: [String : CGRect] = [
        "threePointFiveInchesPhoneFrame": ViewportSizes.threePointFiveInchesPhoneFrame,
        "fourInchesPhoneFrame": ViewportSizes.fourInchesPhoneFrame,
        "fourPointSevenInchesPhoneFrame": ViewportSizes.fourPointSevenInchesPhoneFrame
    ]

    func verifyForScreens(view: UIView) {
        for (identifier, frame) in frames {
            verify(view: view, frame: frame, identifier: identifier)
        }
    }

    func verifyForScreens(view: UIView, updateClosure: (CGRect) -> Void) {
        for (identifier, frame) in frames {
            updateClosure(frame)
            verify(view: view, frame: frame, identifier: identifier)
        }
    }

    func verify(view: UIView, frame: CGRect, identifier: String, file: StaticString = #file, line: UInt = #line) {
        view.frame = frame
        view.layoutIfNeeded()
        FBSnapshotVerifyView(view, identifier: identifier)
        FBSnapshotVerifyLayer(view.layer, identifier: identifier)
    }
}
