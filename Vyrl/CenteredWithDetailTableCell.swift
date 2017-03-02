//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol NamePriceTableCellRendering {
    func render(_ renderable: NamePriceTableCellRenderable)
}

class CenteredWithDetailTableCell: UITableViewCell, HavingNib, NamePriceTableCellRendering {
    static let nibName = "CenteredWithDetailTableCell"

    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var detail: UILabel!
        
    func render(_ renderable: NamePriceTableCellRenderable) {
        self.header.text = renderable.name
        self.detail.text = renderable.price
    }
}
