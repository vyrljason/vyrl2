//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BadgeBarButtonItem: UIBarButtonItem {

    private var badgeButton: ButtonWithBadge!
    let actionClosure: () -> Void

    init(image: UIImage, style: UIBarButtonItemStyle = .plain, action: @escaping () -> Void) {
        actionClosure = action
        super.init()
        customView = badgeButton
        badgeButton = ButtonWithBadge.badgeButton(with: image, action: { [weak self] in self?.didTapButton() })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(_ renderable: BadgeButtonRenderable) {
        badgeButton.render(renderable)
    }

    private func didTapButton() {
        actionClosure()
        if let action = action {
            _ = target?.perform(action)
        }
    }
}

extension BadgeBarButtonItem {
    class func barButtonItem(image: UIImage,
                             style: UIBarButtonItemStyle = .plain,
                             action: @escaping () -> Void) -> BadgeBarButtonItem {
        return BadgeBarButtonItem(image: image, style: style, action: action)
    }
}
