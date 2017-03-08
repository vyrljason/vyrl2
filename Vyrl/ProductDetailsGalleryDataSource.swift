//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsGalleryDataProviding: CollectionViewDataProviding {
    
}

final class ProductDetailsGalleryDataSource: NSObject, ProductDetailsGalleryDataProviding {
    
    weak var collectionViewControllingDelegate: CollectionViewHaving & CollectionViewControlling?
    
    func loadData() { }
    
}

extension ProductDetailsGalleryDataSource: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SwipeableGalleryItemCell = collectionView.dequeueCell(at: indexPath)
        return cell
    }
    
}
