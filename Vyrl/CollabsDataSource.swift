//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 72
}

protocol CollabsDataProviding: CollectionViewManaging, CollectionViewNibRegistering {
    weak var selectionDelegate: CollabSelecting? { get set }
}

final class CollabsDataSource: NSObject, CollabsDataProviding {

    fileprivate let service: CollabsProviding
    fileprivate var items = [Collab]()

    weak var collectionViewControllingDelegate: CollectionViewHaving & CollectionViewControlling?
    weak var selectionDelegate: CollabSelecting?

    init(service: CollabsProviding) {
        self.service = service
        super.init()
    }

    func loadData() {
        service.getCollabs { [weak self] result in
            guard let `self` = self else { return }
            self.items = result.map(success: { $0 }, failure: { _ in return [] })
//            DispatchQueue.onMainThread {
                self.collectionViewControllingDelegate?.updateCollection(with:
                    result.map(success: { $0 .isEmpty ? .empty : .someData },
                               failure: { _ in .error }))
//            }
        }
    }
}

extension CollabsDataSource {
    func registerNibs(in collectionView: UICollectionView) {
        CollabCell.register(to: collectionView)
    }
}

extension CollabsDataSource {

    fileprivate func prepare(cell: CollabCell, using collab: Collab) {
        cell.render(CollabRenderable(collab: collab))
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollabCell = collectionView.dequeueCell(at: indexPath)
        prepare(cell: cell, using: items[indexPath.row])
        return cell
    }
}
extension CollabsDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.didSelect(collab: items[indexPath.row])
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
