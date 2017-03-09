//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsGalleryDataProviding: CollectionViewDataProviding {
    
}

final class ProductDetailsGalleryDataSource: NSObject, ProductDetailsGalleryDataProviding {

    fileprivate let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    weak var collectionViewControllingDelegate: CollectionViewHaving & CollectionViewControlling?
    
    func loadData() { }
    
}

extension ProductDetailsGalleryDataSource: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SwipeableGalleryItemCell = collectionView.dequeueCell(at: indexPath)
        return cell
    }
    
}
