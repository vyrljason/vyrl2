//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsGalleryDataProviding: CollectionViewDataProviding {
    var imagesCount: Int { get }
    weak var pagingDelegate: PagerUpdating? { get set }
}

final class ProductDetailsGalleryDataSource: NSObject, ProductDetailsGalleryDataProviding {
    
    weak var pagingDelegate: PagerUpdating?
    fileprivate let product: Product
    var imagesCount: Int {
        return product.images.count
    }
    
    init(product: Product) {
        self.product = product
    }
    
    weak var collectionViewControllingDelegate: (CollectionViewHaving & CollectionViewControlling)?
}

extension ProductDetailsGalleryDataSource: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pagingDelegate?.scrollViewDidScroll(scrollView)
    }
}

extension ProductDetailsGalleryDataSource: UICollectionViewDataSource {
    
    private func prepare(cell: SwipeableGalleryItemCell, for row: Int) {
        guard row < imagesCount else { return }
        let imageData = product.images[row]
        cell.set(galleryImageFetcher: ImageFetcher(url: imageData.url))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SwipeableGalleryItemCell = collectionView.dequeueCell(at: indexPath)
        prepare(cell: cell, for: indexPath.row)
        return cell
    }
}
