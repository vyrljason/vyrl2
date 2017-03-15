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

private enum Constants {
    static let badgeButtonFrame = CGRect(x: 0, y: 0, width: 42, height: 32)
    static let iconButtonFrame = CGRect(x: 0, y: 0, width: 32, height: 32)
    static let badgeViewInitialSize = CGSize(width: 18, height: 18)
    static let badgeLabelFrame = CGRect(x: 0, y: 0, width: 18, height: 18)
}

final class ButtonWithBadge: UIView, HavingNib {
    static let nibName: String = "ButtonWithBadge"

    private var badgeView: SpringView!
    private var badge: UILabel!
    private var button: UIButton!

    private var actionClosure: (() -> Void)?

    static func badgeButton(with image: UIImage, action: @escaping () -> Void) -> ButtonWithBadge {
        let badgeButton = ButtonWithBadge(frame: Constants.badgeButtonFrame)
        badgeButton.configureButton()
        badgeButton.configureBadgeView()
        badgeButton.setUp(using: image, action: action)
        return badgeButton
    }

    private func configureButton() {
        let button = UIButton(frame: Constants.iconButtonFrame)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        addSubview(button)
        self.button = button
    }

    private func configureBadgeView() {
        let badgeViewX = Constants.iconButtonFrame.size.width - (Constants.badgeViewInitialSize.width / 2.0)
        let badgeView = SpringView(frame: CGRect(x: badgeViewX, y: 0,
                                                 width: Constants.badgeViewInitialSize.width, height: Constants.badgeViewInitialSize.height))
        badgeView.backgroundColor = .white
        let badgeLabelFrame = UILabel(frame: Constants.badgeLabelFrame)
        badgeLabelFrame.font = UIFont.badgeCountFont
        badgeLabelFrame.textAlignment = .center
        badgeView.layer.cornerRadius = badgeView.frame.size.width / 2.0
        badgeView.isHidden = true
        badgeView.addSubview(badgeLabelFrame)
        addSubview(badgeView)
        badge = badgeLabelFrame
        self.badgeView = badgeView
    }

    func render(_ renderable: BadgeButtonRenderable) {
        badge.text = renderable.badge
        badgeView.isHidden = !renderable.isBadgeVisible
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
        case (.none, false):
            badgeView.animation = Spring.AnimationPreset.FadeOut.rawValue
            badgeView.animate()
        case (.some, false):
            badgeView.animation = Spring.AnimationPreset.Pop.rawValue
            badgeView.animate()
        case (.none, true): ()
        }
    }

    private func updateCornerRadius() {
        let badgeWidth = max(badge.intrinsicContentSize.width, Constants.badgeViewInitialSize.width)
        badge.frame = CGRect(origin: badge.frame.origin, size: CGSize(width: badgeWidth, height: badge.frame.height))
        badgeView.frame = CGRect(origin: badgeView.frame.origin, size: CGSize(width: badgeWidth, height: badgeView.frame.height))
    }

    private func setUp(using image: UIImage, action: @escaping () -> Void) {
        button.setImage(image, for: .normal)
        actionClosure = action
    }

    @objc func didTapButton() {
        actionClosure?()
    }
}
