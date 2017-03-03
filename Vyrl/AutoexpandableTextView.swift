//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class AutoexpandableTextView: UITextView {

    @IBOutlet fileprivate weak var height: NSLayoutConstraint?
    @IBInspectable var maxHeight: CGFloat = CGFloat(MAXFLOAT)

    override var attributedText: NSAttributedString! {
        didSet {
            updateHeight()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateHeight()
    }

    func updateHeight() {
        let heightThatFits = sizeThatFits(CGSize(width: frame.width, height: frame.height)).height
        height?.constant = min(heightThatFits, maxHeight)
        superview?.layoutIfNeeded()
    }
}
