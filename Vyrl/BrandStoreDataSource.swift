//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BrandStoreDataSource: NSObject {
    fileprivate let brand: Brand
    fileprivate let service: ProductsProviding
    fileprivate var products = [Product]()
    fileprivate var cellSize: CGSize?
    fileprivate var headerHeight: CGFloat?
    
    weak var delegate: CollectionViewHaving & CollectionViewControlling?
    
    init(brand: Brand,
         service: ProductsProviding) {
        self.brand = brand
        self.service = service
    }
    
    fileprivate func prepare(cell: BrandStoreCell, using product: Product) {
        let renderable = BrandStoreCellRenderable(product: product)
        cell.render(renderable)
    }
}

extension BrandStoreDataSource: UICollectionViewDataSource {
    
    private func prepare(header: BrandStoreHeaderRendering) {
        let renderable = BrandStoreHeaderRenderable(brand: self.brand)
        header.render(renderable)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BrandStoreCell = collectionView.dequeueCell(at: indexPath)
        prepare(cell: cell, using: self.products[indexPath.row])
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: BrandStoreHeader = collectionView.dequeueHeader(at: indexPath)
        header.delegate = self
        prepare(header: header)
        return header
    }
}

extension BrandStoreDataSource: CollectionViewNibRegistering {
    func registerNibs() {
        guard let collectionView = delegate?.collectionView else {
            return
        }
        BrandStoreHeader.registerHeader(to: collectionView)
        BrandStoreCell.register(to: collectionView)
    }
}

extension BrandStoreDataSource: CollectionViewDataProviding {
    func loadData() {
        self.service.get { [weak self] result in
            guard let `self` = self else { return }
            self.products = result.map(success: { $0 }, failure: { _ in return [] })
            DispatchQueue.onMainThread {
                self.delegate?.updateCollection(with: result.map(success: { $0.isEmpty ? .empty : .someData }, failure: { _ in return .error }))
            }
        }
    }
}

extension BrandStoreDataSource: UICollectionViewDelegateFlowLayout {
    
    private func fallbackWidth() -> CGFloat {
        return UIScreen.main.bounds.width * 0.45
    }
    
    private func calculateWidth() -> CGFloat {
        guard let flowLayout = (delegate?.collectionView?.collectionViewLayout) as? UICollectionViewFlowLayout else {
            return fallbackWidth()
        }
        let columns: CGFloat = 2
        let space = (flowLayout.sectionInset.left + flowLayout.sectionInset.right)*0.5 + flowLayout.minimumInteritemSpacing*0.5
        let width: CGFloat = UIScreen.main.bounds.width / columns - space
        return width
    }

    private func calculateHeight() -> CGFloat {
        let cell: BrandStoreCell = BrandStoreCell.fromNib()
        let product: Product = Product(id: "id", name: "Template", retailPrice: 123)
        prepare(cell: cell, using: product)
        cell.sizeToFit()
        return cell.frame.height
    }
    
    private func calculateItemSize() -> CGSize {
        guard let flowLayout = (delegate?.collectionView?.collectionViewLayout) as? UICollectionViewFlowLayout else {
            return CGSize(width: 175, height: 170) // sane fallback
        }
        let columns = 2
        let space = (flowLayout.sectionInset.left + flowLayout.sectionInset.right)*0.5 + flowLayout.minimumInteritemSpacing*0.5
        let width: CGFloat = UIScreen.main.bounds.width / CGFloat(columns) - space
        let height: CGFloat = calculateHeight()
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellSize == nil {
            cellSize = calculateItemSize()
        }
        return cellSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let targetHeight = headerHeight else {
            return CGSize(width: 100, height: 180)
        }
        return CGSize(width: 100, height: targetHeight)
    }
}

extension BrandStoreDataSource: BrandStoreHeaderDelegate {
    func didChangeHeight(height: CGFloat) {
        headerHeight = height
        guard let flowLayout = (delegate?.collectionView?.collectionViewLayout) as? UICollectionViewFlowLayout else {
            return
        }
        delegate?.collectionView?.performBatchUpdates({
            flowLayout.invalidateLayout()
        }, completion: nil)
    }
}
