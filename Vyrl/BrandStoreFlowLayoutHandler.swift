//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let xibHeight = 180
    static let ignoredWidth = 100
    static let fallbackItemSize = CGSize(width: 175, height: 170)
    static let columns = 2
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
            let fallbackItemSize = CGSize(width: 175, height: 170)
            return fallbackItemSize
        }
        let width: CGFloat = calculateWidth(for: flowLayout)
        let height: CGFloat = calculateHeight()
        return CGSize(width: width, height: height)
    }
    
    fileprivate func calculateHeight() -> CGFloat {
        let cell: BrandStoreCell = BrandStoreCell.fromNib()
        let product: Product = Product(id: "id", name: "Template", retailPrice: 123, imageUrls: [])
        let renderable = BrandStoreCellRenderable(product: product)
        cell.render(renderable)
        cell.sizeToFit()
        return cell.frame.height
    }
    
    fileprivate func calculateWidth(for flowLayout: UICollectionViewFlowLayout) -> CGFloat {
        let columnsAsFloat: CGFloat = CGFloat(Constants.columns)
        let insetFractionPerColumn: CGFloat = (flowLayout.sectionInset.left + flowLayout.sectionInset.right) / columnsAsFloat
        let spacingFractionPerColumn: CGFloat = (flowLayout.minimumInteritemSpacing * CGFloat(Constants.columns - 1)) / columnsAsFloat
        let reservedForSeparators = insetFractionPerColumn + spacingFractionPerColumn
        let availableSpacePerColumn = UIScreen.main.bounds.width / columnsAsFloat
        let width: CGFloat = availableSpacePerColumn - reservedForSeparators
        return width
    }
}
