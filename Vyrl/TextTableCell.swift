//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol TextTableCellRendering {
    func render(_ renderable: TextTableCellRenderable)
}

final class TextTableCell: UITableViewCell, HavingNib, TextTableCellRendering {
    static let nibName = "TextTableCell"
    
    @IBOutlet weak var textView: AutoexpandableTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.removeInsets()
    }
    
    func render(_ renderable: TextTableCellRenderable) {
        textView.text = renderable.text
    }
}
