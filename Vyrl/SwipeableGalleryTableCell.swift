//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol SwipeableGalleryDataProviderUsing {
    func useDataProvider(provider: UICollectionViewDataSource & UICollectionViewDelegate)
}

protocol SwipeableGalleryTableCellRendering {
    func render(_ renderable: SwipeableGalleryTableCellRenderable)
}

final class SwipeableGalleryTableCell: UITableViewCell, HavingNib, SwipeableGalleryDataProviderUsing {
    static let nibName = "SwipeableGalleryTableCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pager: UIPageControl!
    
    func useDataProvider(provider: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView.dataSource = provider
        collectionView.delegate = provider
    }
    
    func render(_ renderable: SwipeableGalleryTableCellRenderable) {
        pager.numberOfPages = renderable.imageCount
    }
}
