//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class BrandsDataSource: NSObject {

    fileprivate let repository: BrandsHaving
    fileprivate var items = [Brand]()

    weak var delegate: CollectionViewHaving & CollectionViewControlling?

    init(repository: BrandsHaving) {
        self.repository = repository
        super.init()
    }

    func registerNibs() {
        guard let collectionView = delegate?.collectionView else { return }
        BrandCell.register(to: collectionView)
    }

    fileprivate func prepare(cell: BrandCell, using brand: Brand) {
        cell.render(renderable: BrandRenderable(brand: brand))
        cell.setCoverImage(using: ImageFetcher(url: brand.coverImageURL))
    }
}

extension BrandsDataSource: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BrandCell = collectionView.dequeueCell(at: indexPath)
        prepare(cell: cell, using: items[indexPath.row])
        return cell
    }
}

