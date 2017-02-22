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
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) //stub
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerAtTop : Bool = (kind == UICollectionElementKindSectionHeader) && (indexPath.section == 0)
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: BrandStoreHeader.reusableIdentifier, for: indexPath)
        //TODO: prepare cell
        return header
    }
}

extension BrandStoreDataSource: CollectionViewNibRegistering {
    func registerNibs() {
        guard let collectionView = delegate?.collectionView else { return }
        BrandStoreHeader.register(to: collectionView)
    }
}
