//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CategoryCellRendering {
    func render(_ renderable: CategoryCellRenderable)
}

final class CategoryCell: UICollectionViewCell, HavingNib, CategoryCellRendering {

    static let nibName = "CategoryCell"

    @IBOutlet private weak var name: UILabel!

    func render(_ renderable: CategoryCellRenderable) {
        name.text = renderable.name
    }
}
