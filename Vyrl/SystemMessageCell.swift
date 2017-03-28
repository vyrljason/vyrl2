//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

class SystemMessageCell: UITableViewCell, HavingNib, MessageCellRendering {
    
    static let nibName = "SystemMessageCell"
    
    @IBOutlet fileprivate weak var messageTextView: AutoexpandableTextView!
    
    func render(_ renderable: MessageCellRenderable) {
        messageTextView.text = renderable.text
    }
    
}
