//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CollapsableLabelRendering {
    func toggleCollapse()
    func updateHeight()
}

final class CollapsableLabel: UILabel, CollapsableLabelRendering {
    @IBOutlet private weak var height: NSLayoutConstraint!
    fileprivate var collapsedLineCount: Int?
    fileprivate var isCollapsed = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collapsedLineCount = self.numberOfLines
        self.numberOfLines = 0
    }
    
    func toggleCollapse() {
        isCollapsed = !isCollapsed
        numberOfLines = isCollapsed ? collapsedLineCount! : 0
        updateHeight()
    }
    
    func updateHeight() {
        let targetHeight: CGFloat = isCollapsed ? collapsedDesciptionHeight() : expandedDescriptionHeight()
        height?.constant = targetHeight
        layoutIfNeeded()
    }
    
    fileprivate func collapsedDesciptionHeight() -> CGFloat {
        let font: UIFont = self.font
        let maxCollapsedHeight: CGFloat = font.lineHeight * CGFloat(collapsedLineCount!)
        let expandedHeight = expandedDescriptionHeight()
        return min(maxCollapsedHeight, expandedHeight)
    }
    
    fileprivate func expandedDescriptionHeight() -> CGFloat {
        return sizeThatFits(CGSize(width: frame.width, height: CGFloat(MAXFLOAT))).height
    }
}
