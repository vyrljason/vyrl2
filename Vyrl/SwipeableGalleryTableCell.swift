//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol SwipeableGalleryDataProvicerUsing {
    func useDataProvider(provider: UICollectionViewDataSource & UICollectionViewDelegate)
}

final class SwipeableGalleryTableCell: UITableViewCell, HavingNib {
    static let nibName = "SwipeableGalleryTableCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func useDataProvider(provider: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView.dataSource = provider
        collectionView.delegate = provider
    }
}
