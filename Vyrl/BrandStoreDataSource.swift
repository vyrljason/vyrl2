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
    fileprivate var flowLayoutHandler: BrandStoreFlowLayoutHandling
    weak var delegate: CollectionViewHaving & CollectionViewControlling?
    
    init(brand: Brand,
         service: ProductsProviding,
         flowLayoutHandler: BrandStoreFlowLayoutHandling) {
        self.brand = brand
        self.service = service
        self.flowLayoutHandler = flowLayoutHandler
    }
}

extension BrandStoreDataSource: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        flowLayoutHandler.use(collectionView)
    }
}

extension BrandStoreDataSource: UICollectionViewDataSource {
    private func prepare(cell: BrandStoreCell, using product: Product) {
        let renderable = BrandStoreCellRenderable(product: product)
        cell.render(renderable)
    }
    
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
        header.delegate = self.flowLayoutHandler
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.flowLayoutHandler.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.flowLayoutHandler.headerSize
    }
}
