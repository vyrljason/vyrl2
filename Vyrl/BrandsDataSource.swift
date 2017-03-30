//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 226
}

protocol BrandsDataProviding: CollectionViewManaging, CollectionViewNibRegistering {
    weak var selectionDelegate: BrandSelecting? { get set }
}

protocol BrandsFilteredByCategoryProviding {
    func loadData(filteredBy category: Category?)
}

final class BrandsDataSource: NSObject, BrandsDataProviding {

    fileprivate let service: BrandsProviding
    fileprivate var items = [Brand]()

    weak var collectionViewControllingDelegate: (CollectionViewHaving & CollectionViewControlling)?
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
    func registerNibs(in collectionView: UICollectionView) {
        BrandCell.register(to: collectionView)
    }
}

extension BrandsDataSource: BrandsFilteredByCategoryProviding {
    func loadData(filteredBy category: Category?) {
        service.getFilteredBrands(for: category) { [weak self] result in
            guard let `self` = self else { return }
            self.items = result.map(success: { $0 }, failure: { _ in return [] })
            DispatchQueue.onMainThread {
                self.collectionViewControllingDelegate?.updateCollection(with: result.map(success: { $0 .isEmpty ? .empty : .someData },
                                                                 failure: { _ in .error }))
            }
        }
    }
}

extension BrandsDataSource {

    fileprivate func prepare(cell: BrandCell, using brand: Brand) {
        cell.render(BrandRenderable(brand: brand))
        guard let coverURL = brand.coverImageURL else { return }
        cell.set(coverImageFetcher: ImageFetcher(url: coverURL))
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
        return CGSize(width: collectionViewControllingDelegate?.collectionView?.bounds.width ?? 0, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
