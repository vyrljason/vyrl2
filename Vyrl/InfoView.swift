//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Spring

struct InfoViewRenderable {
    let header: String
    let info: NSAttributedString
    let actionButtonTitle: String
}

final class InfoView: UIView, HavingNib {

    static let nibName: String = "InfoView"

    @IBOutlet private weak var overlayView: SpringView!
    @IBOutlet private weak var mainView: DesignableView!
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var info: AutoexpandableTextView!
    @IBOutlet private weak var actionButton: UIButton!

    @IBAction fileprivate func didTapDismissButton() {
        overlayView.animation = Spring.AnimationPreset.FadeOut.rawValue
        mainView.animation = Spring.AnimationPreset.Fall.rawValue
        mainView.curve = Spring.AnimationCurve.Linear.rawValue
        overlayView.animate()
        mainView.animateNext {
            self.removeFromSuperview()
        }
    }

    func render(renderable: InfoViewRenderable) {
        info.attributedText = renderable.info
        header.text = renderable.header
        actionButton.setTitle(renderable.actionButtonTitle, for: .normal)
    }
}
