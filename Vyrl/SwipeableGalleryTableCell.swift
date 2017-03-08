//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class SwipeableGalleryTableCell: UITableViewCell, HavingNib {
    static let nibName = "SwipeableGalleryTableCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
}
