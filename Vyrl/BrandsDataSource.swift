//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 188
}

final class BrandsDataSource: NSObject {

    fileprivate let repository: BrandsHaving
    fileprivate var items = [Brand]()

    weak var delegate: CollectionViewHaving & CollectionViewControlling?

    init(repository: BrandsHaving) {
        self.repository = repository
        super.init()
    }
}

extension BrandsDataSource: CollectionViewNibRegistering {
    func registerNibs() {
        guard let collectionView = delegate?.collectionView else { return }
        BrandCell.register(to: collectionView)
    }
}

extension BrandsDataSource: CollectionViewDataProviding {
    func loadData() {
        repository.brands { [weak self] result in
            guard let `self` = self else { return }
            self.items = result.map(success: { $0 }, failure: { _ in return [] })
            self.delegate?.reloadData()
        }
    }
}

extension BrandsDataSource: UICollectionViewDataSource {

    fileprivate func prepare(cell: BrandCell, using brand: Brand) {
        cell.render(BrandRenderable(brand: brand))
        cell.set(coverImageFetcher: ImageFetcher(url: brand.coverImageURL))
    }

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
extension BrandsDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: delegate?.collectionView?.bounds.width ?? 0, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
