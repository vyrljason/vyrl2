//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct SingleStatusViewRenderable {
    let status: NSAttributedString
    let showSeparator: Bool
}

final class SingleStatusView: UIView, HavingNib {

    static let nibName: String = "SingleStatusView"
    
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var separator: UIView!
    
    func render(renderable: SingleStatusViewRenderable) {
        statusLabel.attributedText = renderable.status
        separator.isHidden = !renderable.showSeparator
    }

}
