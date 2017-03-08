//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

class SwipeableGalleryItemCell: UICollectionViewCell, HavingNib {
    static let nibName = "SwipeableGalleryItemCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.rouge
    }
}
