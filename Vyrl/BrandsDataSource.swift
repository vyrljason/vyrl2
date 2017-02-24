//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 188
}

protocol BrandsDataProviding: CollectionViewDataProviding, CollectionViewNibRegistering {
    weak var selectionDelegate: BrandSelecting? { get set }
}

protocol LoadingBrandsFilteredByCategory {
    func loadData(filteredBy category: Category?)
}

final class BrandsDataSource: NSObject, BrandsDataProviding {

    fileprivate let service: BrandsProviding
    fileprivate var items = [Brand]()

    weak var delegate: CollectionViewHaving & CollectionViewControlling?
    weak var selectionDelegate: BrandSelecting?

    init(service: BrandsProviding) {
        self.service = service
        super.init()
    }

    func loadData() {
        loadData(filteredBy: nil)
    }
}

extension BrandsDataSource {
    func registerNibs() {
        guard let collectionView = delegate?.collectionView else { return }
        BrandCell.register(to: collectionView)
    }
}

extension BrandsDataSource: LoadingBrandsFilteredByCategory {
    func loadData(filteredBy category: Category?) {
        service.get { [weak self] result in
            guard let `self` = self else { return }
            self.items = result.map(success: { $0 }, failure: { _ in return [] })
            DispatchQueue.onMainThread {
                self.delegate?.updateCollection(with: result.map(success: { $0 .isEmpty ? .empty : .someData },
                                                                 failure: { _ in .error }))
            }
        }
    }
}

extension BrandsDataSource {

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.didSelect(brand: items[indexPath.row])
    }
    
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
