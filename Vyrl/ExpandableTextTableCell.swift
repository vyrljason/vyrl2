//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ExpandableTextTableCellRendering {
    func render(_ renderable: ExpandableTextTableCellRenderable)
    func toggleExpand()
}

final class ExpandableTextTableCell: UITableViewCell, HavingNib, ExpandableTextTableCellRendering {
    static let nibName = "ExpandableTextTableCell"
    
    @IBOutlet weak var textView: ExpandableTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.removeInsets()
    }
    
    func toggleExpand() {
        textView.toggleExpand()
    }
    
    func render(_ renderable: ExpandableTextTableCellRenderable) {
        textView.text = renderable.text
    }
}
