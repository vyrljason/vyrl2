//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 72
}

protocol CollectionUpateListening: class {
    func didUpdateCollection()
}

protocol CollabsDataProviding: CollectionViewControlling, CollectionViewUsing, CollectionViewDataProviding, CollectionViewDataLoading, CollectionViewNibRegistering {
    weak var selectionDelegate: CollabSelecting? { get set }
    weak var reloadingDelegate: ReloadingData? { get set }
    weak var emptyCollectionHandler: EmptyCollectionViewHandling? { get set }
    weak var collectionUpdateListener: CollectionUpateListening? { get set }
}

final class CollabsDataSource: NSObject, CollabsDataProviding {

    fileprivate let service: CollabsProviding
    fileprivate var items = [Collab]()

    weak var emptyCollectionHandler: EmptyCollectionViewHandling?
    weak var selectionDelegate: CollabSelecting?
    weak var reloadingDelegate: ReloadingData?
    weak var collectionView: UICollectionView?
    weak var collectionUpdateListener: CollectionUpateListening?

    init(service: CollabsProviding) {
        self.service = service
        super.init()
    }

    func loadData() {
        service.getCollabs { [weak self] result in
            guard let `self` = self else { return }
            self.items = result.map(success: { $0.sorted(by: { $0.chatRoom.lastActivity > $1.chatRoom.lastActivity} ) }, failure: { _ in return [] })
            DispatchQueue.onMainThread { [weak self] in
                self?.updateCollection(with: result.map(success: { $0 .isEmpty ? .empty : .someData },
                                                        failure: { _ in .error }))
            }
            self.collectionUpdateListener?.didUpdateCollection()
        }
    }
}

extension CollabsDataSource {
    func updateCollection(with result: DataFetchResult) {
        switch result {
        case .error:
            emptyCollectionHandler?.configure(with: .error)
        case .empty:
            emptyCollectionHandler?.configure(with: .noData)
        default: ()
        }
        reloadingDelegate?.reloadData()
    }
}

extension CollabsDataSource {
    func registerNibs(in collectionView: UICollectionView) {
        CollabCell.register(to: collectionView)
    }
}

extension CollabsDataSource: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        registerNibs(in: collectionView)
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
        return CGSize(width: collectionView.bounds.width, height: Constants.cellHeight)
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
