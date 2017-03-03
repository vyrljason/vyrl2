//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol AddToCartTableCellRendering {
    func render(_ renderable: AddToCartTableCellRenderable)
}

final class AddToCartTableCell: UITableViewCell, AddToCartTableCellRendering, HavingNib {
    static let nibName = "AddToCartTableCell"
    
    func render(_ renderable: AddToCartTableCellRenderable) {
        let background = UIView()
        background.backgroundColor = renderable.isEnabled ? UIColor.rouge : UIColor.greyishBrown
        backgroundView = background
    }
}
