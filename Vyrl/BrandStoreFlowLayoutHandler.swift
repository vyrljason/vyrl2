//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let xibHeight = 180
    static let ignoredWidth = 100
    static let fallbackItemSize = CGSize(width: 175, height: 170)
}

protocol BrandStoreFlowLayoutHandling: CollectionViewUsing, BrandStoreHeaderDelegate {
    var headerSize: CGSize { get }
    var itemSize: CGSize { get }
}

final class BrandStoreFlowLayoutHandler: BrandStoreFlowLayoutHandling {
    weak var collectionView: UICollectionView?
    var headerSize: CGSize = CGSize(width: Constants.ignoredWidth, height: Constants.xibHeight)
    var itemSize: CGSize = Constants.fallbackItemSize
    
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        itemSize = calculateItemSize()
    }
    
    func headerDidChangeHeight(height: CGFloat) {
        headerSize.height = height
        guard let flowLayout = (collectionView?.collectionViewLayout) as? UICollectionViewFlowLayout else {
            return
        }
        collectionView?.performBatchUpdates({
            flowLayout.invalidateLayout()
        }, completion: nil)
    }
    
    fileprivate func calculateItemSize() -> CGSize {
        guard let flowLayout = (collectionView?.collectionViewLayout) as? UICollectionViewFlowLayout else {
            return CGSize(width: 175, height: 170) // sane fallback
        }
        let columns = 2
        let space = (flowLayout.sectionInset.left + flowLayout.sectionInset.right)*0.5 + flowLayout.minimumInteritemSpacing*0.5
        let width: CGFloat = UIScreen.main.bounds.width / CGFloat(columns) - space
        let height: CGFloat = calculateHeight()
        return CGSize(width: width, height: height)
    }
    
    fileprivate func calculateHeight() -> CGFloat {
        let cell: BrandStoreCell = BrandStoreCell.fromNib()
        let product: Product = Product(id: "id", name: "Template", retailPrice: 123)
        let renderable = BrandStoreCellRenderable(product: product)
        cell.render(renderable)
        cell.sizeToFit()
        return cell.frame.height
    }
    
    fileprivate func calculateWidth() -> CGFloat {
        guard let flowLayout = (collectionView?.collectionViewLayout) as? UICollectionViewFlowLayout else {
            return fallbackWidth()
        }
        let columns: CGFloat = 2
        let space = (flowLayout.sectionInset.left + flowLayout.sectionInset.right)*0.5 + flowLayout.minimumInteritemSpacing*0.5
        let width: CGFloat = UIScreen.main.bounds.width / columns - space
        return width
    }
    
    fileprivate func fallbackWidth() -> CGFloat {
        return UIScreen.main.bounds.width * 0.45
    }
}
