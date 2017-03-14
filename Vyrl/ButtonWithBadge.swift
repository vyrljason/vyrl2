//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Spring

struct BadgeButtonRenderable {
    let badge: String?
    let isBadgeVisible: Bool

    init(itemsCount: Int) {
        badge = String(itemsCount)
        isBadgeVisible = itemsCount != 0
    }
}

protocol BadgeButtonRendering {
    func render(_ renderable: BadgeButtonRenderable)
}

final class ButtonWithBadge: UIView, HavingNib {
    static let nibName: String = "ButtonWithBadge"

    @IBOutlet private weak var badgeView: SpringView!
    @IBOutlet private weak var badge: UILabel!
    @IBOutlet private weak var button: UIButton!
    private var actionClosure: (() -> Void)?

    static func badgeButton(with image: UIImage, action: @escaping () -> Void) -> ButtonWithBadge {
        let button = ButtonWithBadge.fromNib()
        button.setUp(using: image, action: action)
        return button
    }

    func render(_ renderable: BadgeButtonRenderable) {
        badge.text = renderable.badge
        badgeView.isHidden = renderable.isBadgeVisible
        animateBadge()
        updateCornerRadius()
    }

    private func animateBadge() {
        switch (badge.text, badgeView.isHidden) {
        case (.some, true):
            badgeView.animation = Spring.AnimationPreset.FadeIn.rawValue
            badgeView.animate()
            badgeView.animateNext {
                self.badgeView.animation = Spring.AnimationPreset.Pop.rawValue
                self.badgeView.animate()
            }
        case (.none, true): ()
        case (.none, false): ()
        badgeView.animation = Spring.AnimationPreset.FadeOut.rawValue
        badgeView.animate()
        case (.some, false):
            badgeView.animation = Spring.AnimationPreset.Pop.rawValue
            badgeView.animate()
        }
        if badgeView.isHidden {
            badgeView.animation = Spring.AnimationPreset.FadeIn.rawValue
            badgeView.animate()
        }
    }

    private func updateCornerRadius() {
        badgeView.layer.cornerRadius = badgeView.frame.size.width / 2.0
    }

    private func setUp(using image: UIImage, action: @escaping () -> Void) {
        button.setBackgroundImage(image, for: .normal)
        actionClosure = action
    }

    @IBAction func didTapButton() {
        actionClosure?()
    }
}
