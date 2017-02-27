//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 44.0
}

protocol CategoriesSelectionDelegateHaving: class {
    weak var delegate: CategorySelectionHandling? { get set }
}

final class CategoriesDataSource: NSObject, CategoriesSelectionDelegateHaving {

    fileprivate let service: CategoriesProviding
    fileprivate var items = [Category]()
    fileprivate let emptyTableHandler: EmptyCollectionViewHandling

    weak var delegate: CategorySelectionHandling?

    fileprivate weak var collectionView: UICollectionView?

    init(service: CategoriesProviding, emptyTableHandler: EmptyCollectionViewHandling) {
        self.service = service
        self.emptyTableHandler = emptyTableHandler
        super.init()
    }

    fileprivate func loadData() {
        service.get { [weak self] result in
            guard let `self` = self else { return }
            self.items = result.map(success: { $0 }, failure: { _ in return [] })
            if let mode: EmptyCollectionMode = result.map(success: { $0.isEmpty ? .noData : nil },
                                                          failure: { _ in .error }) {
                self.emptyTableHandler.configure(with: mode)
            } else {
                self.collectionView?.reloadData()
            }
        }
    }
}

extension CategoriesDataSource: CollectionViewNibRegistering {
    func registerNibs(in collectionView: UICollectionView) {
        CategoryCell.register(to: collectionView)
    }
}

extension CategoriesDataSource: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        emptyTableHandler.use(collectionView)
        registerNibs(in: collectionView)
        loadData()
    }
}

extension CategoriesDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(category: items[indexPath.row])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CategoriesDataSource: UICollectionViewDataSource {

    fileprivate func prepare(cell: CategoryCell, using model: Category) {
        cell.render(CategoryCellRenderable(name: model.name))
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCell = collectionView.dequeueCell(at: indexPath)
        prepare(cell: cell, using: items[indexPath.row])
        return cell
    }
}

extension CategoriesDataSource: UICollectionViewDelegateFlowLayout {

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
}
