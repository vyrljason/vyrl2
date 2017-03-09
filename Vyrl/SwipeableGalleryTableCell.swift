//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol SwipeableGalleryDataProviderUsing {
    func useDataProvider(provider: ProductDetailsGalleryDataProviding)
}

protocol SwipeableGalleryTableCellRendering {
    func render(_ renderable: SwipeableGalleryTableCellRenderable)
}

final class SwipeableGalleryTableCell: UITableViewCell, HavingNib, SwipeableGalleryDataProviderUsing {
    static let nibName = "SwipeableGalleryTableCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pager: UIPageControl!
    fileprivate var pagerUpdater: PagerUpdater!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pagerUpdater = PagerUpdater(pager: pager)
    }
    
    func useDataProvider(provider: ProductDetailsGalleryDataProviding) {
        collectionView.dataSource = provider
        collectionView.delegate = provider
        provider.pagingDelegate = pagerUpdater
    }
    
    func render(_ renderable: SwipeableGalleryTableCellRenderable) {
        pager.numberOfPages = renderable.imageCount
    }
}
