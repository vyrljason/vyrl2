//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ExpandableTextView: UITextView {
    
    @IBInspectable var updatesHeightConstraint: Bool = false
    @IBOutlet fileprivate weak var heightConstraint: NSLayoutConstraint?
    fileprivate var isExpanded: Bool = false
    fileprivate var contractedHeight: CGFloat = 0
    fileprivate var expandedHeight: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heightConstraint?.isActive = updatesHeightConstraint
        contractedHeight = heightConstraint?.constant ?? 0
    }
    
    func toggleExpand() {
        isExpanded = !isExpanded
        refreshHeight()
    }
    
    func targetHeight() -> CGFloat {
        let expanded = max(expandedHeight, contractedHeight)
        return isExpanded ? expanded : contractedHeight
    }

    override var attributedText: NSAttributedString! {
        didSet {
            refreshHeight()
        }
    }
    
    override var text: String! {
        didSet {
            refreshHeight()
        }
    }
    
    fileprivate func refreshHeight() {
        expandedHeight = sizeThatFits(CGSize(width: frame.width, height: CGFloat(MAXFLOAT))).height
        if updatesHeightConstraint {
            heightConstraint?.constant = targetHeight()
        }
    }
}
