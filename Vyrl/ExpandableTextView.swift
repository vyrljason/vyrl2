//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class ExpandableTextView: UITextView {
    
    @IBOutlet fileprivate weak var heightConstraint: NSLayoutConstraint?
    fileprivate var isExpanded: Bool = false
    fileprivate var contractedHeight: CGFloat = 0
    fileprivate var expandedHeight: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contractedHeight = (heightConstraint?.constant)!
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
    
    func toggleExpand() {
        isExpanded = !isExpanded
        refreshHeight()
    }
    
    func targetHeight() -> CGFloat {
        return isExpanded ? expandedHeight : contractedHeight
    }
    
    fileprivate func refreshHeight() {
        expandedHeight = sizeThatFits(CGSize(width: frame.width, height: CGFloat(MAXFLOAT))).height
        heightConstraint?.constant = targetHeight()
        superview?.layoutIfNeeded()
    }
}
