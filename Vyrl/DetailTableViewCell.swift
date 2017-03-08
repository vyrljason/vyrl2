//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol DetailTableCellRendering {
    func render(_ renderable: DetailTableCellRenderable)
}

class DetailTableViewCell: UITableViewCell, HavingNib, DetailTableCellRendering {
    static let nibName = "DetailTableViewCell"
    
    @IBOutlet var name: UILabel!
    @IBOutlet var detail: UITextField!
    @IBOutlet var asterisk: UILabel!
    
    func render(_ renderable: DetailTableCellRenderable) {
        name.text = renderable.text
        detail.text = renderable.detail
        asterisk.isHidden = !renderable.mandatory
    }
}
