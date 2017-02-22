//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BrandStoreDataSource: NSObject {
    fileprivate let brand: Brand
    
    weak var delegate: CollectionViewHaving & CollectionViewControlling?
    
    init(brand: Brand) {
        self.brand = brand
    }
}

extension BrandStoreDataSource: UICollectionViewDataSource {

    fileprivate func prepare(header: BrandStoreHeaderRendering, using brand: Brand) {
        let renderable = BrandStoreHeaderRenderable(title: brand.name, textCollapsed: brand.name, textExpanded: nil)
        header.render(_: renderable)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) //stub
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: BrandStoreHeader = collectionView.dequeueHeader(at: indexPath)
        prepare(header: header, using: self.brand)
        return header
    }
}

extension BrandStoreDataSource: CollectionViewNibRegistering {
    func registerNibs() {
        guard let collectionView = delegate?.collectionView else {
            return
        }
        BrandStoreHeader.registerAsHeader(to: collectionView)
    }
}

extension BrandStoreDataSource: CollectionViewDataProviding {
    func loadData() {
        self.delegate?.updateCollection(with: .empty)
    }
}
